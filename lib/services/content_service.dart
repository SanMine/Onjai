import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/element_content.dart';

/// Service for fetching element-specific content
class ContentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get element content for a specific element
  Future<ElementContent?> getElementContent(String element) async {
    try {
      final doc = await _firestore
          .collection('content')
          .doc(element)
          .get();

      if (!doc.exists) {
        return null;
      }

      return ElementContent.fromMap(element, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get element content for $element: $e');
    }
  }

  /// Stream element content for real-time updates
  Stream<ElementContent?> streamElementContent(String element) {
    return _firestore
        .collection('content')
        .doc(element)
        .snapshots()
        .map((doc) {
      if (!doc.exists) return null;
      return ElementContent.fromMap(element, doc.data()!);
    });
  }

  /// Get all element content for all elements
  Future<Map<String, ElementContent>> getAllElementContent() async {
    try {
      final elements = ['Fire', 'Water', 'Wind', 'Earth'];
      final results = <String, ElementContent>{};

      for (final element in elements) {
        final content = await getElementContent(element);
        if (content != null) {
          results[element] = content;
        }
      }

      return results;
    } catch (e) {
      throw Exception('Failed to get all element content: $e');
    }
  }

  /// Check if element content exists
  Future<bool> elementContentExists(String element) async {
    try {
      final doc = await _firestore
          .collection('content')
          .doc(element)
          .get();

      return doc.exists;
    } catch (e) {
      return false;
    }
  }

  /// Create or update element content
  Future<void> setElementContent(ElementContent content) async {
    try {
      await _firestore
          .collection('content')
          .doc(content.element)
          .set(content.toMap());
    } catch (e) {
      throw Exception('Failed to set element content for ${content.element}: $e');
    }
  }

  /// Delete element content
  Future<void> deleteElementContent(String element) async {
    try {
      await _firestore
          .collection('content')
          .doc(element)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete element content for $element: $e');
    }
  }
}
