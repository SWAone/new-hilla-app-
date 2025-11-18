import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/tour_scene.dart';

/// Manages scene loading, caching, and navigation.
class SceneManager {
  final BuildContext context;
  final Map<String, TourScene> scenes;

  SceneManager({
    required this.context,
    required this.scenes,
  });

  /// Preloads all scene images in the background.
  /// Uses CachedNetworkImageProvider for better caching.
  Future<void> precacheAllScenes() async {
    for (final scene in scenes.values) {
      if (!context.mounted) return;
      if (scene.imageUrl.isNotEmpty) {
        try {
          // Use CachedNetworkImageProvider for better caching
          final imageProvider = CachedNetworkImageProvider(scene.imageUrl);
          await precacheImage(imageProvider, context);
        } catch (e) {
          // Continue with other images if one fails
          debugPrint('Error precaching scene image: $e');
        }
      }
    }
  }

  /// Preloads a specific scene image.
  /// Uses CachedNetworkImageProvider for better caching.
  Future<void> precacheScene(TourScene scene) async {
    if (!context.mounted) return;
    if (scene.imageUrl.isNotEmpty) {
      try {
        // Use CachedNetworkImageProvider for better caching
        final imageProvider = CachedNetworkImageProvider(scene.imageUrl);
        await precacheImage(imageProvider, context);
      } catch (e) {
        debugPrint('Error precaching scene image: $e');
      }
    }
  }

  /// Gets a scene by its ID.
  TourScene? getScene(String sceneId) {
    return scenes[sceneId];
  }

  /// Checks if a scene exists.
  bool hasScene(String sceneId) {
    return scenes.containsKey(sceneId);
  }
}

