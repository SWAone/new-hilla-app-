import 'package:flutter/material.dart';

/// UI controls overlay for the panorama view.
class PanoramaControls extends StatelessWidget {
  final String sceneName;
  final bool canGoBack;
  final VoidCallback? onBackPressed;
  final double currentZoom;
  final VoidCallback? onZoomIn;
  final VoidCallback? onZoomOut;

  const PanoramaControls({
    super.key,
    required this.sceneName,
    required this.canGoBack,
    this.onBackPressed,
    required this.currentZoom,
    this.onZoomIn,
    this.onZoomOut,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            // Back button
            Align(
              alignment: Alignment.topLeft,
              child: AnimatedOpacity(
                opacity: canGoBack ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: IconButton.filled(
                  onPressed: canGoBack ? onBackPressed : null,
                  icon: const Icon(Icons.arrow_back),
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.black54,
                  ),
                ),
              ),
            ),
            // Scene name
            Align(
              alignment: Alignment.topCenter,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Text(
                    sceneName,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            // Zoom controls
            Align(
              alignment: Alignment.bottomRight,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: onZoomOut,
                        icon: const Icon(Icons.zoom_out),
                        color: Colors.white,
                      ),
                      Text(
                        '${currentZoom.toStringAsFixed(1)}x',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: Colors.white),
                      ),
                      IconButton(
                        onPressed: onZoomIn,
                        icon: const Icon(Icons.zoom_in),
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

