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
  late final Map<String, TourScene> _scenesById;
  final List<String> _sceneHistory = [];
  late TourScene _activeScene;
  late SceneManager _sceneManager;

  static const double _minZoom = 1.0;
  static const double _maxZoom = 4.0;
  double _zoom = 1.0;
  GlobalKey _panoramaKey = GlobalKey();
  bool _isSceneTransitioning = false;
  bool _showPreviewOverlay = false;
  String? _previewAssetPath;

  @override
  void initState() {
    super.initState();
    _scenesById = SceneData.buildScenes();
    _activeScene = _scenesById['gate']!;
    _sceneHistory.add(_activeScene.id);
    _sceneManager = SceneManager(
      context: context,
      scenes: _scenesById,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sceneManager.precacheAllScenes();
    });
  }

  /// Navigates to a target scene with smooth transition.
  Future<void> _goToScene(String targetSceneId) async {
    if (!_sceneManager.hasScene(targetSceneId) || _isSceneTransitioning) {
      return;
    }
    final targetScene = _sceneManager.getScene(targetSceneId)!;
    setState(() {
      _isSceneTransitioning = true;
    });
    await _sceneManager.precacheScene(targetScene);
    if (!mounted) return;
    setState(() {
      _panoramaKey = GlobalKey();
      _zoom = _minZoom;
      _sceneHistory.add(targetSceneId);
      _activeScene = targetScene;
      _previewAssetPath = targetScene.assetPath;
      _showPreviewOverlay = true;
    });
  }

  /// Navigates back to the previous scene.
  Future<void> _popScene() async {
    if (_sceneHistory.length <= 1 || _isSceneTransitioning) return;
    final targetSceneId = _sceneHistory[_sceneHistory.length - 2];
    final targetScene = _sceneManager.getScene(targetSceneId)!;
    setState(() {
      _isSceneTransitioning = true;
    });
    await _sceneManager.precacheScene(targetScene);
    if (!mounted) return;
    setState(() {
      _panoramaKey = GlobalKey();
      _zoom = _minZoom;
      _sceneHistory.removeLast();
      _activeScene = targetScene;
      _previewAssetPath = targetScene.assetPath;
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
          _previewAssetPath = null;
          _isSceneTransitioning = false;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                key: ValueKey(_activeScene.id),
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
                    child: Image.asset(_activeScene.assetPath),
                    hotspots: _activeScene.hotspots.map((hotspot) {
                      return Hotspot(
                        latitude: hotspot.pitch,
                        longitude: hotspot.yaw,
                        width: hotspot.width ?? 72,
                        height: hotspot.height ?? 72,
                        widget: GestureDetector(
                          onTap: () {
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
            sceneName: _activeScene.name,
            canGoBack: _sceneHistory.length > 1,
            onBackPressed: _popScene,
            currentZoom: _zoom,
            onZoomIn: () => _adjustZoom(0.25),
            onZoomOut: () => _adjustZoom(-0.25),
          ),
          // Preview overlay during transition
          if (_showPreviewOverlay && _previewAssetPath != null)
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedOpacity(
                  opacity: 1,
                  duration: const Duration(milliseconds: 150),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(color: Colors.black),
                    child: Image.asset(
                      _previewAssetPath!,
                      fit: BoxFit.cover,
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

