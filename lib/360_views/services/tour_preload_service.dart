import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/scene_data.dart';
import '../models/tour_scene.dart';

/// Service for preloading tour scene images in the background
class TourPreloadService {
  static bool _isPreloading = false;
  static bool _isPreloaded = false;
  static Map<String, TourScene>? _preloadedScenes;

  /// Checks if preloading is in progress
  static bool get isPreloading => _isPreloading;

  /// Checks if scenes are already preloaded
  static bool get isPreloaded => _isPreloaded;

  /// Gets the preloaded scenes if available
  static Map<String, TourScene>? get preloadedScenes => _preloadedScenes;

  /// Preloads all tour scenes and their images in the background
  /// This should be called when the app starts to ensure images are ready
  static Future<void> preloadScenes(BuildContext context) async {
    // If already preloading or preloaded, skip
    if (_isPreloading || _isPreloaded) {
      return;
    }

    try {
      _isPreloading = true;
      debugPrint('TourPreloadService: Starting preload...');

      // Load scenes from API
      final scenes = await SceneData.buildScenes();
      
      if (!context.mounted || scenes.isEmpty) {
        _isPreloading = false;
        return;
      }

      _preloadedScenes = scenes;

      // Preload all scene images
      for (final scene in scenes.values) {
        if (!context.mounted) {
          debugPrint('TourPreloadService: Context unmounted, stopping preload');
          break;
        }

        if (scene.imageUrl.isNotEmpty) {
          try {
            // Use CachedNetworkImageProvider for better caching
            final imageProvider = CachedNetworkImageProvider(scene.imageUrl);
            await precacheImage(imageProvider, context);
            debugPrint('TourPreloadService: Preloaded image for scene: ${scene.name}');
          } catch (e) {
            debugPrint('TourPreloadService: Error preloading image for ${scene.name}: $e');
            // Continue with other images even if one fails
          }
        }
      }

      _isPreloaded = true;
      _isPreloading = false;
      debugPrint('TourPreloadService: Preload completed successfully');
    } catch (e) {
      debugPrint('TourPreloadService: Error during preload: $e');
      _isPreloading = false;
    }
  }

  /// Resets the preload state (useful for testing or forcing reload)
  static void reset() {
    _isPreloading = false;
    _isPreloaded = false;
    _preloadedScenes = null;
  }
}

