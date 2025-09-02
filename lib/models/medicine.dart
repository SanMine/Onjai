/// Model for medicine items
class Medicine {
  final String id;
  final String name;
  final String imageKey;
  final String category;
  final String path;

  const Medicine({
    required this.id,
    required this.name,
    required this.imageKey,
    required this.category,
    required this.path,
  });

  /// Create Medicine from Firestore document data
  factory Medicine.fromMap(String id, Map<String, dynamic> data, {required String path}) {
    // Derive category from nested path: medicines/{Category}/medicine/{id}
    final parts = path.split('/');
    String derivedCategory = data['category'] ?? '';
    final idx = parts.indexOf('medicines');
    if (idx != -1 && idx + 1 < parts.length) {
      derivedCategory = parts[idx + 1];
    }
    return Medicine(
      id: id,
      name: data['name'] ?? '',
      imageKey: data['imageKey'] ?? '',
      category: derivedCategory,
      path: path,
    );
  }

  /// Convert Medicine to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageKey': imageKey,
      'category': category,
    };
  }

  /// Get display name with proper capitalization
  String get displayName {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  String toString() {
    return 'Medicine(id: $id, name: $name, imageKey: $imageKey, category: $category, path: $path)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Medicine &&
        other.id == id &&
        other.name == name &&
        other.imageKey == imageKey &&
        other.category == category &&
        other.path == path;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageKey.hashCode ^
        category.hashCode ^
        path.hashCode;
  }
}
