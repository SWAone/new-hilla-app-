import 'package:flutter/material.dart';
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
  Future<void> precacheAllScenes() async {
    for (final scene in scenes.values) {
      if (!context.mounted) return;
      if (scene.imageUrl.isNotEmpty) {
        await precacheImage(NetworkImage(scene.imageUrl), context)
            .catchError((_) {});
      }
    }
  }

  /// Preloads a specific scene image.
  Future<void> precacheScene(TourScene scene) async {
    if (!context.mounted) return;
    if (scene.imageUrl.isNotEmpty) {
      await precacheImage(NetworkImage(scene.imageUrl), context)
          .catchError((_) {});
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

