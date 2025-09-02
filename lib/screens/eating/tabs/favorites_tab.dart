import 'package:flutter/material.dart';

import '../../../models/food.dart';
import '../../../services/favorites_service.dart';
import '../../../services/foods_service.dart';
import '../../../widgets/food_tile.dart';

/// Tab for showing user's favorite foods
class FavoritesTab extends StatelessWidget {
  final String element;
  final FoodsService foodsService;
  final FavoritesService favoritesService;
  final String userId;

  const FavoritesTab({
    super.key,
    required this.element,
    required this.foodsService,
    required this.favoritesService,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<String>>(
      stream: favoritesService.getFavoriteFoodPaths(userId),
      builder: (context, favoritePathsSnapshot) {
        if (favoritePathsSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (favoritePathsSnapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'Error loading favorites',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  favoritePathsSnapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final favoritePaths = favoritePathsSnapshot.data ?? [];

        if (favoritePaths.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No favorite foods yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap the heart icon on any food to add it to your favorites',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return FutureBuilder<List<Food>>(
          future: foodsService.getFoodsByPaths(favoritePaths),
          builder: (context, foodsSnapshot) {
            if (foodsSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (foodsSnapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading favorite foods',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      foodsSnapshot.error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            final foods = foodsSnapshot.data ?? [];

            if (foods.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorite foods found',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Some of your favorite foods may have been removed or are from an old format',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: foods.length,
              itemBuilder: (context, index) {
                final food = foods[index];
                return StreamBuilder<bool>(
                  stream: favoritesService.isFoodFavorited(userId, food.id),
                  builder: (context, favoriteSnapshot) {
                    final isFavorite = favoriteSnapshot.data ?? false;
                    
                    return FoodTile(
                      food: food,
                      isFavorite: isFavorite,
                      onToggleFavorite: () => _toggleFavorite(food),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  /// Toggle favorite status for a food
  Future<void> _toggleFavorite(Food food) async {
    try {
      await favoritesService.toggleFavorite(userId, food.firestorePath);
    } catch (e) {
      // Error handling is done in the service
      print('Error toggling favorite: $e');
    }
  }
}
