import 'package:cloud_firestore/cloud_firestore.dart';

/// User profile model for storing user information in Firestore
class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final DateTime dob;
  final String dayOfWeek;
  final String element;
  final String photoUrl;
  final List<String> favorites;

  const UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.dob,
    required this.dayOfWeek,
    required this.element,
    this.photoUrl = '',
    this.favorites = const [],
  });

  /// Create UserProfile from Firestore document data
  factory UserProfile.fromMap(String uid, Map<String, dynamic> data) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      dob: (data['dob'] as Timestamp).toDate(),
      dayOfWeek: data['dayOfWeek'] ?? '',
      element: data['element'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      favorites: List<String>.from(data['favorites'] ?? []),
    );
  }

  /// Convert UserProfile to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'displayName': displayName,
      'email': email,
      'dob': Timestamp.fromDate(dob),
      'dayOfWeek': dayOfWeek,
      'element': element,
      'photoUrl': photoUrl,
      'favorites': favorites,
    };
  }

  /// Check if the user profile is complete (has all required fields)
  bool get isComplete {
    return displayName.isNotEmpty &&
           dayOfWeek.isNotEmpty &&
           element.isNotEmpty &&
           element != 'Unknown';
  }

  /// Create a copy of UserProfile with updated fields
  UserProfile copyWith({
    String? uid,
    String? displayName,
    String? email,
    DateTime? dob,
    String? dayOfWeek,
    String? element,
    String? photoUrl,
    List<String>? favorites,
  }) {
    return UserProfile(
      uid: uid ?? this.uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      element: element ?? this.element,
      photoUrl: photoUrl ?? this.photoUrl,
      favorites: favorites ?? this.favorites,
    );
  }

  @override
  String toString() {
    return 'UserProfile(uid: $uid, displayName: $displayName, email: $email, dob: $dob, dayOfWeek: $dayOfWeek, element: $element, photoUrl: $photoUrl, favorites: $favorites)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.uid == uid &&
        other.displayName == displayName &&
        other.email == email &&
        other.dob == dob &&
        other.dayOfWeek == dayOfWeek &&
        other.element == element &&
        other.photoUrl == photoUrl &&
        other.favorites == favorites;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        displayName.hashCode ^
        email.hashCode ^
        dob.hashCode ^
        dayOfWeek.hashCode ^
        element.hashCode ^
        photoUrl.hashCode ^
        favorites.hashCode;
  }
}
