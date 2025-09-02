import 'package:flutter/material.dart';
import '../models/food.dart';
import '../utils/asset_mapper.dart';

/// Reusable widget for displaying food items with favorite toggle
class FoodTile extends StatelessWidget {
  final Food food;
  final bool isFavorite;
  final VoidCallback? onToggleFavorite;
  final VoidCallback? onTap;
  final bool showFavoriteButton;

  const FoodTile({
    super.key,
    required this.food,
    required this.isFavorite,
    this.onToggleFavorite,
    this.onTap,
    this.showFavoriteButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 80,
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Food image
              _buildFoodImage(),
              const SizedBox(width: 12),
              
              // Food details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      food.displayName,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    _buildCategoryChip(),
                  ],
                ),
              ),
              
              // Favorite button
              if (showFavoriteButton) _buildFavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build food image using local asset
  Widget _buildFoodImage() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey[200],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          AssetMapper.getAssetPath(food.imageKey),
          fit: BoxFit.cover,
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
      ),
    );
  }

  /// Build error placeholder
  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Icon(
        Icons.restaurant,
        color: Colors.grey[400],
        size: 24,
      ),
    );
  }

  /// Build category chip
  Widget _buildCategoryChip() {
    Color chipColor;
    IconData chipIcon;
    
    switch (food.category) {
      case FoodCategory.great:
        chipColor = Colors.green;
        chipIcon = Icons.thumb_up;
        break;
      case FoodCategory.avoid:
        chipColor = Colors.red;
        chipIcon = Icons.thumb_down;
        break;
      case FoodCategory.suggestion:
        chipColor = Colors.orange;
        chipIcon = Icons.lightbulb;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chipColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            chipIcon,
            size: 12,
            color: chipColor,
          ),
          const SizedBox(width: 4),
          Text(
            food.category.value.toUpperCase(),
            style: TextStyle(
              color: chipColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Build favorite toggle button
  Widget _buildFavoriteButton() {
    return IconButton(
      onPressed: onToggleFavorite,
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.grey[400],
        size: 24,
      ),
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
    );
  }
}
