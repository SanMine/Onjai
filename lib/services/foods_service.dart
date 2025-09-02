import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/food.dart';

/// Service for fetching and managing food items
/// 
/// Firestore Schema (Nested Layout):
/// Collection: foods
/// Document: {element} (Fire, Water, Wind, Earth)
///   Collection: {category} (great, avoid, suggestion)
///     Document: {foodId}
///       {
///         "name": "ginger",
///         "imageKey": "ginger"
///       }
/// 
/// Path format: foods/{element}/{category}/{foodId}
/// Element and category are derived from the path, not stored in the document.
class FoodsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const int _pageSize = 20;

  /// Get foods by category and element with pagination
  /// 
  /// Path: foods/{element}/{category}
  Stream<List<Food>> getFoodsByCategoryAndElement(
    FoodCategory category,
    String element, {
    DocumentSnapshot? lastDocument,
  }) {
    print('FoodsService: Loading foods for element=$element, category=${category.value}');
    
    Query query = _firestore
        .collection('foods')
        .doc(element)
        .collection(category.value)
        .orderBy('name')
        .limit(_pageSize);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.snapshots().map((snapshot) {
      print('FoodsService: Found ${snapshot.docs.length} foods in foods/$element/${category.value}');
      return snapshot.docs.map((doc) {
        return Food.fromMap(doc.id, doc.data() as Map<String, dynamic>, element, category.value);
      }).toList();
    });
  }

  /// Get all foods for an element (all categories)
  /// 
  /// Merges results from foods/{element}/great + avoid + suggestion
  Stream<List<Food>> getAllFoodsForElement(String element) {
    print('FoodsService: Loading all foods for element=$element');
    
    // Use a single stream from the great category for now
    // This can be enhanced later if needed
    return _firestore
        .collection('foods')
        .doc(element)
        .collection('great')
        .orderBy('name')
        .limit(20)
        .snapshots()
        .map((snapshot) {
      final foods = snapshot.docs.map((doc) {
        return Food.fromMap(doc.id, doc.data() as Map<String, dynamic>, element, 'great');
      }).toList();
      
      print('FoodsService: Found ${foods.length} foods for element=$element');
      return foods;
    });
  }



  /// Get food by ID (requires element and category)
  Future<Food?> getFoodById(String foodId, String element, FoodCategory category) async {
    try {
      print('FoodsService: Loading food by ID=$foodId, element=$element, category=${category.value}');
      
      final doc = await _firestore
          .collection('foods')
          .doc(element)
          .collection(category.value)
          .doc(foodId)
          .get();
      
      if (!doc.exists) {
        print('FoodsService: Food not found at foods/$element/${category.value}/$foodId');
        return null;
      }

      return Food.fromMap(doc.id, doc.data()!, element, category.value);
    } catch (e) {
      print('FoodsService: Error loading food by ID: $e');
      throw Exception('Failed to get food by ID $foodId: $e');
    }
  }

  /// Get foods by IDs (for favorites) - requires full paths
  /// 
  /// Paths format: "foods/{element}/{category}/{foodId}"
  Future<List<Food>> getFoodsByPaths(List<String> foodPaths) async {
    if (foodPaths.isEmpty) return [];

    try {
      print('FoodsService: Loading foods by paths: ${foodPaths.length} paths');
      
      final allFoods = <Food>[];
      
      for (final path in foodPaths) {
        try {
          final food = await _getFoodByPath(path);
          if (food != null) {
            allFoods.add(food);
          }
        } catch (e) {
          print('FoodsService: Error loading food at path $path: $e');
          // Continue with other paths
        }
      }

      print('FoodsService: Successfully loaded ${allFoods.length} foods from paths');
      return allFoods;
    } catch (e) {
      throw Exception('Failed to get foods by paths: $e');
    }
  }

  /// Helper to get food by full path
  Future<Food?> _getFoodByPath(String path) async {
    try {
      // Parse path: "foods/{element}/{category}/{foodId}"
      final parts = path.split('/');
      if (parts.length != 4 || parts[0] != 'foods') {
        print('FoodsService: Invalid path format: $path');
        return null;
      }
      
      final element = parts[1];
      final category = parts[2];
      final foodId = parts[3];
      
      final doc = await _firestore.doc(path).get();
      
      if (!doc.exists) {
        print('FoodsService: Food not found at path: $path');
        return null;
      }

      return Food.fromMap(foodId, doc.data()!, element, category);
    } catch (e) {
      print('FoodsService: Error parsing path $path: $e');
      return null;
    }
  }

  /// Search foods by name within an element
  /// 
  /// Performs prefix search in the great category
  Stream<List<Food>> searchFoods(String query, String element) {
    if (query.isEmpty) {
      return getAllFoodsForElement(element);
    }

    print('FoodsService: Searching foods for element=$element, query="$query"');
    
    return _firestore
        .collection('foods')
        .doc(element)
        .collection('great')
        .orderBy('name')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .limit(20)
        .snapshots()
        .map((snapshot) {
      final foods = snapshot.docs.map((doc) {
        return Food.fromMap(doc.id, doc.data() as Map<String, dynamic>, element, 'great');
      }).toList();
      
      print('FoodsService: Search found ${foods.length} foods for query="$query"');
      return foods;
    });
  }

  /// Get food statistics for an element
  Future<Map<String, int>> getFoodStatsForElement(String element) async {
    try {
      print('FoodsService: Getting stats for element=$element');
      
      final stats = <String, int>{};
      
      for (final category in FoodCategory.values) {
        final snapshot = await _firestore
            .collection('foods')
            .doc(element)
            .collection(category.value)
            .get();
        
        stats[category.value] = snapshot.docs.length;
        print('FoodsService: ${category.value}: ${snapshot.docs.length} foods');
      }

      return stats;
    } catch (e) {
      print('FoodsService: Error getting stats: $e');
      throw Exception('Failed to get food stats for element $element: $e');
    }
  }

  /// Create a new food item
  Future<void> createFood(Food food) async {
    try {
      print('FoodsService: Creating food at path: ${food.firestorePath}');
      
      await _firestore
          .collection('foods')
          .doc(food.element)
          .collection(food.category.value)
          .doc(food.id)
          .set(food.toMap());
    } catch (e) {
      print('FoodsService: Error creating food: $e');
      throw Exception('Failed to create food: $e');
    }
  }

  /// Update an existing food item
  Future<void> updateFood(Food food) async {
    try {
      print('FoodsService: Updating food at path: ${food.firestorePath}');
      
      await _firestore
          .collection('foods')
          .doc(food.element)
          .collection(food.category.value)
          .doc(food.id)
          .update(food.toMap());
    } catch (e) {
      print('FoodsService: Error updating food: $e');
      throw Exception('Failed to update food: $e');
    }
  }

  /// Delete a food item
  Future<void> deleteFood(String foodId, String element, FoodCategory category) async {
    try {
      print('FoodsService: Deleting food at path: foods/$element/${category.value}/$foodId');
      
      await _firestore
          .collection('foods')
          .doc(element)
          .collection(category.value)
          .doc(foodId)
          .delete();
    } catch (e) {
      print('FoodsService: Error deleting food: $e');
      throw Exception('Failed to delete food: $e');
    }
  }
}
