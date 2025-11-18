import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:hilla_medi_app/360_views/data/scene_data.dart';
import 'package:hilla_medi_app/360_views/models/tour_scene.dart';
import 'package:hilla_medi_app/360_views/services/scene_manager.dart';
import 'package:hilla_medi_app/360_views/widgets/hotspot_widgets.dart';
import 'package:hilla_medi_app/360_views/widgets/panorama_controls.dart';
import 'package:panorama/panorama.dart';


/// Main screen for the virtual university tour.
class VirtualTourScreen extends StatefulWidget {
  const VirtualTourScreen({super.key});

  @override
  State<VirtualTourScreen> createState() => _VirtualTourScreenState();
}

class _VirtualTourScreenState extends State<VirtualTourScreen> {
  Map<String, TourScene>? _scenesById;
  final List<String> _sceneHistory = [];
  TourScene? _activeScene;
  SceneManager? _sceneManager;
  bool _isLoading = true;
  String? _errorMessage;

  static const double _minZoom = 1.0;
  static const double _maxZoom = 4.0;
  double _zoom = 1.0;
  GlobalKey _panoramaKey = GlobalKey();
  int _panoramaInstanceId = 0; // Unique ID to force rebuild
  bool _isSceneTransitioning = false;
  bool _showPreviewOverlay = false;
  String? _previewImageUrl;

  @override
  void initState() {
    super.initState();
    _resetState();
    _loadScenes();
  }

  void _resetState() {
    _scenesById = null;
    _sceneHistory.clear();
    _activeScene = null;
    _sceneManager = null;
    _isLoading = true;
    _errorMessage = null;
    _zoom = _minZoom;
    _panoramaKey = GlobalKey();
    _panoramaInstanceId = 0; // Reset instance ID
    _isSceneTransitioning = false;
    _showPreviewOverlay = false;
    _previewImageUrl = null;
  }

  Future<void> _loadScenes() async {
    try {
      // Reset loading state
      if (mounted) {
        setState(() {
          _isLoading = true;
          _errorMessage = null;
        });
      }

      final scenes = await SceneData.buildScenes();
      if (!mounted) return;
      
      setState(() {
        _scenesById = scenes;
        // Find first scene or use 'gate' as default
        _activeScene = scenes.values.isNotEmpty 
            ? scenes.values.first 
            : (scenes.containsKey('gate') ? scenes['gate'] : null);
        if (_activeScene != null) {
          _sceneHistory.clear();
          _sceneHistory.add(_activeScene!.id);
          _sceneManager = SceneManager(
            context: context,
            scenes: _scenesById!,
          );
          // Reset panorama key to force rebuild
          _panoramaKey = GlobalKey();
          _panoramaInstanceId++; // Increment to force rebuild
          _zoom = _minZoom;
          _isSceneTransitioning = false;
          _showPreviewOverlay = false;
          _previewImageUrl = null;
        }
        _isLoading = false;
        _errorMessage = null;
      });

      // Precache scenes after loading
      if (_sceneManager != null && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _sceneManager!.precacheAllScenes();
          }
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'فشل تحميل المشاهد: $e';
        _isLoading = false;
      });
    }
  }

  /// Navigates to a target scene with smooth transition.
  Future<void> _goToScene(String targetSceneId) async {
    if (_sceneManager == null || _scenesById == null || _isSceneTransitioning) {
      debugPrint('Cannot navigate: _sceneManager=${_sceneManager != null}, _scenesById=${_scenesById != null}, _isSceneTransitioning=$_isSceneTransitioning');
      return;
    }
    
    debugPrint('Navigating to scene: $targetSceneId');
    debugPrint('Available scenes: ${_scenesById!.keys.toList()}');
    
    // Try to find scene by targetSceneId (could be sceneId or id)
    TourScene? targetScene;
    
    // First, try direct lookup by key
    if (_scenesById!.containsKey(targetSceneId)) {
      targetScene = _scenesById![targetSceneId];
      debugPrint('Found scene by direct key: $targetSceneId');
    } else {
      // If not found, try to find by matching id in all scenes
      try {
        targetScene = _scenesById!.values.firstWhere(
          (scene) => scene.id.toLowerCase() == targetSceneId.toLowerCase(),
        );
        debugPrint('Found scene by matching id: ${targetScene.id}');
      } catch (e) {
        debugPrint('Scene not found: $targetSceneId. Available: ${_scenesById!.keys.toList()}');
        // Show error to user
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('المشهد "$targetSceneId" غير موجود'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }
    
    if (targetScene == null) {
      debugPrint('Target scene is null after search');
      return;
    }
    
    setState(() {
      _isSceneTransitioning = true;
    });
    await _sceneManager!.precacheScene(targetScene);
    if (!mounted) return;
    setState(() {
      _panoramaKey = GlobalKey();
      _zoom = _minZoom;
      _sceneHistory.add(targetScene!.id);
      _activeScene = targetScene;
      _previewImageUrl = targetScene.imageUrl;
      _showPreviewOverlay = true;
    });
  }

  /// Navigates back to the previous scene.
  Future<void> _popScene() async {
    if (_sceneManager == null || _sceneHistory.length <= 1 || _isSceneTransitioning) return;
    final targetSceneId = _sceneHistory[_sceneHistory.length - 2];
    final targetScene = _sceneManager!.getScene(targetSceneId)!;
    setState(() {
      _isSceneTransitioning = true;
    });
    await _sceneManager!.precacheScene(targetScene);
    if (!mounted) return;
    setState(() {
      _panoramaKey = GlobalKey();
      _zoom = _minZoom;
      _sceneHistory.removeLast();
      _activeScene = targetScene;
      _previewImageUrl = targetScene.imageUrl;
      _showPreviewOverlay = true;
    });
  }

  /// Adjusts the zoom level.
  void _adjustZoom(double delta) {
    final nextZoom = (_zoom + delta).clamp(_minZoom, _maxZoom);
    final state = _panoramaKey.currentState;
    if (state == null) return;
    final dynamic panoramaState = state;
    final scene = panoramaState.scene;
    if (scene == null) return;
    panoramaState.setState(() {
      scene.camera.zoom = nextZoom;
      panoramaState.zoomDelta = 0;
      scene.update();
    });
    setState(() {
      _zoom = nextZoom;
    });
  }

  /// Creates a simple black placeholder image for failed image loads.
  /// Returns a minimal 512x512 black PNG image as bytes (larger size for panorama).
  Uint8List _createPlaceholderImage() {
    // Create a larger placeholder (512x512) for panorama view
    // This is a minimal valid PNG with black color
    // Using a simple approach: create a data URI style minimal PNG
    // For now, return a 1x1 transparent PNG that will be stretched
    // The actual size doesn't matter much as it will be stretched to fit
    return Uint8List.fromList([
      0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
      0x00, 0x00, 0x00, 0x0D, // IHDR chunk length
      0x49, 0x48, 0x44, 0x52, // IHDR
      0x00, 0x00, 0x02, 0x00, // width: 512 (0x0200)
      0x00, 0x00, 0x02, 0x00, // height: 512 (0x0200)
      0x08, 0x06, 0x00, 0x00, 0x00, // bit depth: 8, color type: RGBA
      0x1F, 0x15, 0xC4, 0x89, // CRC
      0x00, 0x00, 0x00, 0x0C, // IDAT chunk length
      0x49, 0x44, 0x41, 0x54, // IDAT
      0x78, 0x9C, 0x63, 0x00, 0x01, 0x00, 0x00, 0x05, 0x00, 0x01, // compressed data (black)
      0x0D, 0x0A, 0x2D, 0xB4, // CRC
      0x00, 0x00, 0x00, 0x00, // IEND chunk length
      0x49, 0x45, 0x4E, 0x44, // IEND
      0xAE, 0x42, 0x60, 0x82, // CRC
    ]);
  }

  /// Handles view changes from the panorama widget.
  void _handleViewChanged(double longitude, double latitude, double tilt) {
    final state = _panoramaKey.currentState;
    if (state == null) return;
    final dynamic panoramaState = state;
    final scene = panoramaState.scene;
    if (scene == null) return;
    final currentZoom = scene.camera.zoom.clamp(_minZoom, _maxZoom);
    bool needsSetState = false;
    double? nextZoom;
    if ((currentZoom - _zoom).abs() > 0.01) {
      nextZoom = currentZoom;
      needsSetState = true;
    }
    if (_showPreviewOverlay || _isSceneTransitioning) {
      needsSetState = true;
    }
    if (needsSetState) {
      setState(() {
        if (nextZoom != null) {
          _zoom = nextZoom;
        }
        if (_showPreviewOverlay || _isSceneTransitioning) {
          _showPreviewOverlay = false;
          _previewImageUrl = null;
          _isSceneTransitioning = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading state
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      );
    }

    // Show error state
    if (_errorMessage != null || _scenesById == null || _activeScene == null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 64),
              const SizedBox(height: 16),
              Text(
                _errorMessage ?? 'لا توجد مشاهد متاحة',
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadScenes,
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Panorama view
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 420),
              switchInCurve: Curves.easeInOut,
              switchOutCurve: Curves.easeInOut,
              layoutBuilder: (currentChild, previousChildren) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ...previousChildren,
                    if (currentChild != null) currentChild,
                  ],
                );
              },
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
              child: KeyedSubtree(
                key: ValueKey('${_activeScene!.id}_$_panoramaInstanceId'),
                child: IgnorePointer(
                  ignoring: _isSceneTransitioning,
                  child: Panorama(
                    key: _panoramaKey,
                    animSpeed: 0.0,
                    zoom: _zoom,
                    minZoom: _minZoom,
                    maxZoom: _maxZoom,
                    sensitivity: 1.4,
                    onViewChanged: _handleViewChanged,
                    child: _activeScene!.imageUrl.isNotEmpty
                        ? Image.network(
                            _activeScene!.imageUrl,
                            fit: BoxFit.cover,
                            cacheWidth: null, // Allow full resolution
                            cacheHeight: null,
                            headers: const {
                              'Cache-Control': 'no-cache',
                            },
                            errorBuilder: (context, error, stackTrace) {
                              debugPrint('Error loading image: $error');
                              debugPrint('Image URL: ${_activeScene!.imageUrl}');
                              // Return a placeholder Image widget (not Container)
                              return Image.asset(
                                'assets/images/placeholder.png',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // If placeholder doesn't exist, create a simple colored image
                                  return Image.memory(
                                    _createPlaceholderImage(),
                                    fit: BoxFit.cover,
                                  );
                                },
                              );
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                // Image loaded successfully, return the child
                                return child;
                              }
                              // Show loading indicator overlay instead of placeholder
                              return Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.memory(
                                    _createPlaceholderImage(),
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    color: Colors.black54,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                            : null,
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          )
                        : Image.memory(
                            _createPlaceholderImage(),
                            fit: BoxFit.cover,
                          ),
                    hotspots: _activeScene!.hotspots.map((hotspot) {
                      return Hotspot(
                        latitude: hotspot.pitch,
                        longitude: hotspot.yaw,
                        width: hotspot.width ?? 72,
                        height: hotspot.height ?? 72,
                        widget: GestureDetector(
                          onTap: () {
                            debugPrint('Hotspot tapped: targetSceneId=${hotspot.targetSceneId}');
                            if (hotspot.onTap != null) {
                              hotspot.onTap!();
                            } else {
                              _goToScene(hotspot.targetSceneId);
                            }
                          },
                          child: HotspotWidgets.buildHotspotWidget(hotspot),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          // UI Controls
          PanoramaControls(
            sceneName: _activeScene!.name,
            canGoBack: _sceneHistory.length > 1,
            onBackPressed: _popScene,
            currentZoom: _zoom,
            onZoomIn: () => _adjustZoom(0.25),
            onZoomOut: () => _adjustZoom(-0.25),
            onExit: () => Navigator.of(context).pop(),
          ),
          // Preview overlay during transition
          if (_showPreviewOverlay && _previewImageUrl != null)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 150),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Image.network(
                      _previewImageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        debugPrint('Error loading preview image: $error');
                        return Container(
                          color: Colors.black,
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          // Loading indicator during transition
          if (_isSceneTransitioning)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator.adaptive(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

