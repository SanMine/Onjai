import 'package:flutter/material.dart';

/// Reusable widget for displaying full-bleed posters using local assets
class PosterView extends StatelessWidget {
  final String imageKey;
  final double? height;
  final double? width;
  final BoxFit fit;
  final Widget? overlay;
  final VoidCallback? onTap;
  final BorderRadius? borderRadius;

  const PosterView({
    super.key,
    required this.imageKey,
    this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.overlay,
    this.onTap,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
        ),
        clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background poster image using local asset
            Image.asset(
              _getAssetPath(),
              fit: fit,
              errorBuilder: (context, error, stackTrace) => _buildErrorPlaceholder(),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded) return child;
                return AnimatedOpacity(
                  opacity: frame == null ? 0 : 1,
                  duration: const Duration(milliseconds: 300),
                  child: child,
                );
              },
            ),
            
            // Overlay (if provided)
            if (overlay != null) overlay!,
          ],
        ),
      ),
    );
  }

  /// Get asset path for the image key
  String _getAssetPath() {
    // Import AssetMapper here to avoid circular dependencies
    const Map<String, String> assetMap = {
      // Element posters
      'fire_dashboard': 'assets/images/posters/fire_dashboard.jpg',
      'fire_travel': 'assets/images/posters/fire_travel.jpg',
      'fire_selfcare': 'assets/images/posters/fire_selfcare.jpg',
      'water_dashboard': 'assets/images/posters/water_dashboard.jpg',
      'water_travel': 'assets/images/posters/water_travel.jpg',
      'water_selfcare': 'assets/images/posters/water_selfcare.jpg',
      'wind_dashboard': 'assets/images/posters/wind_dashboard.jpg',
      'wind_travel': 'assets/images/posters/wind_travel.jpg',
      'wind_selfcare': 'assets/images/posters/wind_selfcare.jpg',
      'earth_dashboard': 'assets/images/posters/earth_dashboard.jpg',
      'earth_travel': 'assets/images/posters/earth_travel.jpg',
      'earth_selfcare': 'assets/images/posters/earth_selfcare.jpg',
      // Add other mappings as needed
    };
    
    return assetMap[imageKey] ?? 'assets/images/app/app_placeholder_therapy.png';
  }

  /// Build error placeholder
  Widget _buildErrorPlaceholder() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.broken_image,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 8),
            Text(
              'Image not available',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full-screen poster view with gradient overlay for text contrast
class FullScreenPosterView extends StatelessWidget {
  final String imageKey;
  final Widget? content;
  final List<Color>? gradientColors;
  final AlignmentGeometry? gradientBegin;
  final AlignmentGeometry? gradientEnd;

  const FullScreenPosterView({
    super.key,
    required this.imageKey,
    this.content,
    this.gradientColors,
    this.gradientBegin,
    this.gradientEnd,
  });

  @override
  Widget build(BuildContext context) {
    return PosterView(
      imageKey: imageKey,
      height: double.infinity,
      width: double.infinity,
      fit: BoxFit.cover,
      overlay: _buildGradientOverlay(),
    );
  }

  /// Build gradient overlay for text contrast
  Widget _buildGradientOverlay() {
    if (content == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors ?? [
            Colors.transparent,
            Colors.black.withOpacity(0.3),
            Colors.black.withOpacity(0.7),
          ],
          begin: gradientBegin ?? Alignment.topCenter,
          end: gradientEnd ?? Alignment.bottomCenter,
        ),
      ),
      child: content,
    );
  }
}
