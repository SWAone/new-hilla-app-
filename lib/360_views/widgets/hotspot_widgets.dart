import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/tour_scene.dart';

/// Widget builder for hotspot UI elements.
class HotspotWidgets {
  /// Builds the default modern hotspot widget with glassmorphism effect.
  static Widget buildDefaultHotspot(Color color) {
    final glowColor = color.withOpacity(0.45);
    final accent = HSLColor.fromColor(color).withLightness(0.6).toColor();
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                glowColor,
                Colors.transparent,
              ],
              stops: const [0.5, 1.0],
            ),
          ),
        ),
        Container(
          width: 62,
          height: 62,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: SweepGradient(
              colors: [
                color.withOpacity(0.95),
                color.withOpacity(0.6),
                color.withOpacity(0.95),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: glowColor,
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
        ),
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.25),
                  width: 1.5,
                ),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.35),
                    accent.withOpacity(0.22),
                  ],
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.arrow_outward_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Builds a label-based hotspot widget.
  static Widget buildLabelHotspot(String label, Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color,
          width: 1.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  /// Builds the appropriate widget for a hotspot based on its configuration.
  static Widget buildHotspotWidget(TourHotspot hotspot) {
    if (hotspot.widget != null) {
      return hotspot.widget!;
    }
    if (hotspot.label != null) {
      return buildLabelHotspot(hotspot.label!, hotspot.iconColor);
    }
    return buildDefaultHotspot(hotspot.iconColor);
  }
}

