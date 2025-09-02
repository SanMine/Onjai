import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

/// Service for handling user profile operations in Firestore
class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Get user profile from Firestore
  /// Returns null if the user profile doesn't exist
  Future<UserProfile?> getUserProfile(String uid) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      return UserProfile.fromMap(uid, doc.data()!);
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Create or update user profile in Firestore
  /// Uses set() with merge: true to create or update
  Future<void> upsertUserProfile(UserProfile profile) async {
    try {
      await _firestore
          .collection('users')
          .doc(profile.uid)
          .set(profile.toMap(), SetOptions(merge: true));
    } catch (e) {
      throw Exception('Failed to save user profile: $e');
    }
  }

  /// Create a new user profile with basic information
  /// This is typically called after user registration
  Future<UserProfile> createInitialProfile({
    required String uid,
    required String email,
  }) async {
    final profile = UserProfile(
      uid: uid,
      displayName: '',
      email: email,
      dob: DateTime.now(), // Placeholder, will be updated
      dayOfWeek: '',
      element: '',
      photoUrl: '',
      favorites: [],
    );

    await upsertUserProfile(profile);
    return profile;
  }

  /// Update specific fields of a user profile
  Future<void> updateProfileFields({
    required String uid,
    String? displayName,
    DateTime? dob,
    String? dayOfWeek,
    String? element,
    String? photoUrl,
    List<String>? favorites,
  }) async {
    try {
      final updates = <String, dynamic>{};
      
      if (displayName != null) updates['displayName'] = displayName;
      if (dob != null) updates['dob'] = Timestamp.fromDate(dob);
      if (dayOfWeek != null) updates['dayOfWeek'] = dayOfWeek;
      if (element != null) updates['element'] = element;
      if (photoUrl != null) updates['photoUrl'] = photoUrl;
      if (favorites != null) updates['favorites'] = favorites;

      await _firestore
          .collection('users')
          .doc(uid)
          .update(updates);
    } catch (e) {
      throw Exception('Failed to update profile fields: $e');
    }
  }

  /// Check if a user profile exists and is complete
  Future<bool> isProfileComplete(String uid) async {
    try {
      final profile = await getUserProfile(uid);
      return profile?.isComplete ?? false;
    } catch (e) {
      // If there's an error, assume profile is incomplete
      return false;
    }
  }

  /// Delete user profile (for cleanup purposes)
  Future<void> deleteUserProfile(String uid) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .delete();
    } catch (e) {
      throw Exception('Failed to delete user profile: $e');
    }
  }

  /// Update a single field in user profile
  Future<void> updateUserField(String uid, String field, dynamic value) async {
    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .update({field: value});
    } catch (e) {
      throw Exception('Failed to update user field $field: $e');
    }
  }
}
