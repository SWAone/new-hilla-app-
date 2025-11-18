import 'package:flutter/material.dart';
import '../../shared/env.dart';

/// Immutable description of one tour location.
class TourScene {
  const TourScene({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.hotspots,
  });

  final String id;
  final String name;
  final String imageUrl;
  final List<TourHotspot> hotspots;

  /// Create TourScene from JSON
  factory TourScene.fromJson(Map<String, dynamic> json) {
    // Use sceneId from API as the id for navigation, fallback to _id or id
    final id = (json['sceneId'] ?? json['_id'] ?? json['id']).toString();
    
    // Get image URL - prefer imageFullUrl, fallback to imageUrl
    String imageUrl;
    if (json['imageFullUrl'] != null) {
      final fullUrl = json['imageFullUrl'].toString();
      // Normalize localhost URLs to use Env.baseUrl
      if (fullUrl.contains('localhost') || fullUrl.contains('127.0.0.1') || fullUrl.contains('::1')) {
        final uri = Uri.tryParse(fullUrl);
        if (uri != null) {
          final relativePath = uri.path.replaceFirst('/uploads/', '');
          imageUrl = '${Env.baseUrl}/uploads/$relativePath';
        } else {
          imageUrl = fullUrl;
        }
      } else {
        imageUrl = fullUrl;
      }
    } else if (json['imageUrl'] != null) {
      final relativePath = json['imageUrl'].toString();
      if (relativePath.isNotEmpty && !relativePath.startsWith('http')) {
        // Remove leading slash if present
        final normalizedPath = relativePath.startsWith('/') 
            ? relativePath.substring(1) 
            : relativePath;
        imageUrl = '${Env.baseUrl}/uploads/$normalizedPath';
      } else {
        imageUrl = relativePath;
      }
    } else {
      imageUrl = '';
    }

    // Parse hotspots
    final hotspotsJson = json['hotspots'] as List<dynamic>? ?? [];
    final hotspots = hotspotsJson
        .map((h) => TourHotspot.fromJson(h as Map<String, dynamic>))
        .toList();

    return TourScene(
      id: id,
      name: (json['name'] ?? '').toString(),
      imageUrl: imageUrl,
      hotspots: hotspots,
    );
  }

  /// Convert TourScene to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'hotspots': hotspots.map((h) => h.toJson()).toList(),
    };
  }
}

/// Configuration for a single hotspot inside a panorama.
class TourHotspot {
  const TourHotspot({
    required this.yaw,
    required this.pitch,
    required this.targetSceneId,
    this.iconColor = Colors.redAccent,
    this.tooltip,
    this.label,
    this.onTap,
    this.widget,
    this.width,
    this.height,
  });

  /// Horizontal angle in degrees (0 faces forward, positive turns right).
  final double yaw;

  /// Vertical angle in degrees (0 is horizon, negative looks up).
  final double pitch;

  /// Scene to navigate to when tapped.
  final String targetSceneId;

  /// Color for the hotspot icon.
  final Color iconColor;

  /// Optional tooltip displayed on long-press.
  final String? tooltip;

  /// Optional text label rendered instead of the default icon.
  final String? label;

  /// Optional custom tap handler. When provided, navigation is skipped.
  final VoidCallback? onTap;

  /// Optional widget to render at the hotspot's location (takes priority).
  final Widget? widget;

  /// Optional width override for the hotspot widget.
  final double? width;

  /// Optional height override for the hotspot widget.
  final double? height;

  /// Create TourHotspot from JSON
  factory TourHotspot.fromJson(Map<String, dynamic> json) {
    // Parse iconColor from hex string
    Color iconColor = Colors.redAccent;
    if (json['iconColor'] != null) {
      try {
        final hexString = json['iconColor'].toString().replaceAll('#', '');
        iconColor = Color(int.parse('FF$hexString', radix: 16));
      } catch (e) {
        // Keep default color if parsing fails
      }
    }

    return TourHotspot(
      yaw: (json['yaw'] ?? 0).toDouble(),
      pitch: (json['pitch'] ?? 0).toDouble(),
      targetSceneId: (json['targetSceneId'] ?? '').toString(),
      iconColor: iconColor,
      tooltip: json['tooltip']?.toString(),
      label: json['label']?.toString(),
      width: json['width'] != null ? (json['width'] as num).toDouble() : null,
      height: json['height'] != null ? (json['height'] as num).toDouble() : null,
    );
  }

  /// Convert TourHotspot to JSON
  Map<String, dynamic> toJson() {
    // Convert Color to hex string
    String colorHex = '#FF0000';
    try {
      final colorValue = iconColor.value.toRadixString(16).substring(2);
      colorHex = '#$colorValue';
    } catch (e) {
      // Keep default
    }

    return {
      'yaw': yaw,
      'pitch': pitch,
      'targetSceneId': targetSceneId,
      'iconColor': colorHex,
      if (tooltip != null) 'tooltip': tooltip,
      if (label != null) 'label': label,
      if (width != null) 'width': width,
      if (height != null) 'height': height,
    };
  }
}

