import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/medicine.dart';

class MedicinesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get medicines by IDs (for therapy recommendations)
  /// 
  /// Uses simple document ID queries (no composite index needed)
  Future<List<Medicine>> getMedicinesByIds(List<String> medicineIds) async {
    // Deprecated in new nested schema - keep for back-compat if needed
    return [];
  }

  // Deprecated: flat root by ID (kept only for legacy compatibility); returns null
  Future<Medicine?> getMedicineById(String medicineId) async {
    return null;
  }


  // Admin-only: create in nested path
  Future<void> createMedicine(String category, Medicine medicine) async {
    try {
      await _firestore.collection('medicines').doc(category).collection('medicine').doc(medicine.id).set(medicine.toMap());
    } catch (e) {
      throw Exception('Failed to create medicine: $e');
    }
  }

  Future<void> updateMedicine(String category, Medicine medicine) async {
    try {
      await _firestore.collection('medicines').doc(category).collection('medicine').doc(medicine.id).update(medicine.toMap());
    } catch (e) {
      throw Exception('Failed to update medicine: $e');
    }
  }

  Future<void> deleteMedicine(String category, String medicineId) async {
    try {
      await _firestore.collection('medicines').doc(category).collection('medicine').doc(medicineId).delete();
    } catch (e) {
      throw Exception('Failed to delete medicine: $e');
    }
  }

  /// Stream medicines by category (flat schema, element-agnostic)
  Stream<List<Medicine>> getByCategory(String category) {
    return _firestore
        .collection('medicines')
        .doc(category)
        .collection('medicine')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((d) => Medicine.fromMap(d.id, d.data() as Map<String, dynamic>, path: d.reference.path))
            .toList());
  }

  Future<List<Medicine>> getByIdsInCategory(String category, List<String> ids) async {
    if (ids.isEmpty) return [];
    final results = <Medicine>[];
    for (int i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, (i + 10 > ids.length) ? ids.length : i + 10);
      final snap = await _firestore
          .collection('medicines')
          .doc(category)
          .collection('medicine')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();
      results.addAll(snap.docs.map((d) => Medicine.fromMap(d.id, d.data() as Map<String, dynamic>, path: d.reference.path)));
    }
    return results;
  }

  Future<Medicine?> getByPathOrId({required String category, required String id}) async {
    final doc = await _firestore.collection('medicines').doc(category).collection('medicine').doc(id).get();
    if (!doc.exists) return null;
    return Medicine.fromMap(doc.id, doc.data() as Map<String, dynamic>, path: doc.reference.path);
  }

  Stream<List<Medicine>> searchInCategory(String category, String queryPrefix) {
    if (queryPrefix.isEmpty) return getByCategory(category);
    return _firestore
        .collection('medicines')
        .doc(category)
        .collection('medicine')
        .orderBy('name')
        .startAt([queryPrefix])
        .endAt(['$queryPrefix\uf8ff'])
        .limit(20)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((d) => Medicine.fromMap(d.id, d.data() as Map<String, dynamic>, path: d.reference.path))
            .toList());
  }

  /// Toggle favorite path in users/{uid}.favorites_medicine_paths (array of full paths)
  Future<void> toggleFavoritePath(String uid, String docPath) async {
    final userRef = _firestore.collection('users').doc(uid);
    final snap = await userRef.get();
    final data = snap.data() as Map<String, dynamic>?;
    final current = Set<String>.from((data?['favorites_medicine_paths'] as List?) ?? []);
    if (current.contains(docPath)) {
      await userRef.update({'favorites_medicine_paths': FieldValue.arrayRemove([docPath])});
    } else {
      await userRef.set({'favorites_medicine_paths': FieldValue.arrayUnion([docPath])}, SetOptions(merge: true));
    }
  }

  /// Stream favorite paths set
  Stream<Set<String>> streamFavoritePaths(String uid) {
    return _firestore.collection('users').doc(uid).snapshots().map((snap) {
      final data = snap.data() as Map<String, dynamic>?;
      final list = (data?['favorites_medicine_paths'] as List?) ?? [];
      return Set<String>.from(list.map((e) => e.toString()));
    });
  }
}
