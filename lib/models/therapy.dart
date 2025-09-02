/// Simple model for therapy documents by body part
///
/// Firestore schema:
/// therapy/{BodyPart}
/// Fields: imageKey (String), description (String)
class Therapy {
  final String id;
  final String imageKey;
  final String description;

  const Therapy({
    required this.id,
    required this.imageKey,
    required this.description,
  });

  /// Creates a Therapy instance from Firestore document data
  factory Therapy.fromMap(String id, Map<String, dynamic> data) => Therapy(
        id: id,
        imageKey: (data['imageKey'] ?? '').toString(),
        description: (data['description'] ?? '').toString(),
      );

  /// Converts this Therapy instance to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'imageKey': imageKey,
      'description': description,
    };
  }

  @override
  String toString() {
    return 'Therapy(id: $id, imageKey: $imageKey, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Therapy &&
        other.id == id &&
        other.imageKey == imageKey &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^ imageKey.hashCode ^ description.hashCode;
  }
}
