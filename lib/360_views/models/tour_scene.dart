import 'package:flutter/material.dart';

/// Immutable description of one tour location.
class TourScene {
  const TourScene({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.hotspots,
  });

  final String id;
  final String name;
  final String assetPath;
  final List<TourHotspot> hotspots;
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
}

