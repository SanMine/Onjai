import 'package:flutter/material.dart';

import '../../../models/food.dart';
import '../../../services/favorites_service.dart';
import '../../../services/foods_service.dart';
import '../../../widgets/food_tile.dart';

/// Tab for showing foods that should be avoided for the user's element
class AvoidTab extends StatelessWidget {
  final String element;
  final FoodsService foodsService;
  final FavoritesService favoritesService;
  final String userId;

  const AvoidTab({
    super.key,
    required this.element,
    required this.foodsService,
    required this.favoritesService,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Food>>(
      stream: foodsService.getFoodsByCategoryAndElement(
        FoodCategory.avoid,
        element,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
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
                  'Error loading foods',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  snapshot.error.toString(),
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final foods = snapshot.data ?? [];

        if (foods.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.restaurant,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No foods to avoid found',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'Check back later for recommendations',
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
