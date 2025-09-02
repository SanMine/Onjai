import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/therapy.dart';

/// Service for fetching therapy documents by body part
///
/// Firestore Schema:
/// therapy/{BodyPart} (e.g., Leg, Arm, Shoulder)
/// Fields: imageKey (String), description (String)
class TherapyService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get therapy by body part (one-shot)
  Future<Therapy?> getByBodyPart(String bodyPart) async {
    try {
      final snap = await _db.collection('therapy').doc(bodyPart).get();
      if (!snap.exists) return null;
      return Therapy.fromMap(snap.id, Map<String, dynamic>.from(snap.data()!));
    } catch (e) {
      rethrow;
    }
  }

  /// Stream therapy by body part (real-time)
  Stream<Therapy?> streamByBodyPart(String bodyPart) {
    return _db.collection('therapy').doc(bodyPart).snapshots().map((s) {
      if (!s.exists) return null;
      return Therapy.fromMap(s.id, Map<String, dynamic>.from(s.data()!));
    });
  }
}
