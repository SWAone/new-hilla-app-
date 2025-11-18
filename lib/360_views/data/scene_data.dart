import 'package:flutter/material.dart';
import '../models/tour_scene.dart';
import '../../data/tour_repository.dart';
import '../../shared/env.dart';

/// Provides all tour scenes data.
class SceneData {
  static final TourRepository _repository = TourRepository();

  /// Builds and returns all available tour scenes from API.
  /// Falls back to static data if API fails.
  static Future<Map<String, TourScene>> buildScenes() async {
    try {
      // Try to load from API
      final scenes = await _repository.fetchActiveTourScenes();
      
      if (scenes.isNotEmpty) {
        // Convert list to map using scene id
        final Map<String, TourScene> scenesMap = {};
        for (final scene in scenes) {
          scenesMap[scene.id] = scene;
        }
        return scenesMap;
      }
    } catch (e) {
      debugPrint('Error loading tour scenes from API: $e');
      // Fall through to static data
    }

    // Fallback to static data if API fails or returns empty
    return _getDefaultScenes();
  }

  /// Default static scenes as fallback
  static Map<String, TourScene> _getDefaultScenes() {
    return {
      'gate': TourScene(
        id: 'gate',
        name: 'بوابة جامعة الحلة',
        imageUrl: '${Env.baseUrl}/uploads/images/tours/default-gate.jpg',
        hotspots: [
          const TourHotspot(
            yaw: 0,
            pitch: -5,
            targetSceneId: 'hall',
            iconColor: Colors.redAccent,
            tooltip: 'Enter Main Hall',
          ),
        ],
      ),
      'hall': TourScene(
        id: 'hall',
        name: 'سنترال بناية حمورابي',
        imageUrl: '${Env.baseUrl}/uploads/images/tours/default-hall.jpg',
        hotspots: const [
          TourHotspot(
            yaw: 30,
            pitch: -10,
            targetSceneId: 'presdnt',
            iconColor: Color.fromARGB(255, 13, 111, 124),
            tooltip: 'Return to Gate',
          ),
        ],
      ),
    };
  }
}
