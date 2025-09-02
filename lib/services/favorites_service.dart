import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for managing user food favorites
/// 
/// Updated to store full Firestore paths: "foods/{element}/{category}/{foodId}"
/// Maintains backward compatibility with old favorites that only store food IDs
class FavoritesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user's favorite food paths
  Stream<List<String>> getFavoriteFoodPaths(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favoriteFoods')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        // Check if this is a new path-based favorite or old ID-based favorite
        if (data.containsKey('path')) {
          return data['path'] as String;
        } else {
          // Old format: just store the ID, we'll handle this in the UI
          return doc.id;
        }
      }).toList();
    });
  }

  /// Check if a food is favorited by user
  Stream<bool> isFoodFavorited(String userId, String foodId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favoriteFoods')
        .doc(foodId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  /// Add food to favorites using full path
  Future<void> addToFavorites(String userId, String foodPath) async {
    try {
      // Extract food ID from path for the document ID
      final parts = foodPath.split('/');
      final foodId = parts.last;
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteFoods')
          .doc(foodId)
          .set({
        'path': foodPath,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to add food to favorites: $e');
    }
  }

  /// Remove food from favorites
  Future<void> removeFromFavorites(String userId, String foodId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteFoods')
          .doc(foodId)
          .delete();
    } catch (e) {
      throw Exception('Failed to remove food from favorites: $e');
    }
  }

  /// Toggle food favorite status using full path
  Future<void> toggleFavorite(String userId, String foodPath) async {
    try {
      // Extract food ID from path for the document ID
      final parts = foodPath.split('/');
      final foodId = parts.last;
      
      final docRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteFoods')
          .doc(foodId);
      
      final doc = await docRef.get();
      
      if (doc.exists) {
        await docRef.delete();
      } else {
        await docRef.set({
          'path': foodPath,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Failed to toggle favorite: $e');
    }
  }

  /// Get favorite foods with metadata
  Stream<List<Map<String, dynamic>>> getFavoriteFoodsWithMetadata(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favoriteFoods')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'foodId': doc.id,
          'path': data['path'] as String?, // New format
          'createdAt': data['createdAt'] as Timestamp?,
        };
      }).toList();
    });
  }

  /// Clear all favorites for a user
  Future<void> clearAllFavorites(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('favoriteFoods')
          .get();
      
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      
      await batch.commit();
    } catch (e) {
      throw Exception('Failed to clear favorites: $e');
    }
  }

  /// Get favorite count for a user
  Stream<int> getFavoriteCount(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('favoriteFoods')
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }
}
