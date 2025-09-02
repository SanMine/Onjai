/// Food categories for filtering
enum FoodCategory {
  great,
  avoid,
  suggestion,
}

/// Extension to convert category to string
extension FoodCategoryExtension on FoodCategory {
  String get value {
    switch (this) {
      case FoodCategory.great:
        return 'great';
      case FoodCategory.avoid:
        return 'avoid';
      case FoodCategory.suggestion:
        return 'suggestion';
    }
  }

  static FoodCategory fromString(String value) {
    switch (value) {
      case 'great':
        return FoodCategory.great;
      case 'avoid':
        return FoodCategory.avoid;
      case 'suggestion':
        return FoodCategory.suggestion;
      default:
        throw ArgumentError('Invalid food category: $value');
    }
  }
}

/// Model for food items
/// 
/// In the nested Firestore layout:
/// - Element and category are derived from the document path
/// - Document only contains: { name, imageKey }
/// - Path format: foods/{element}/{category}/{foodId}
class Food {
  final String id;
  final String name;
  final String imageKey;
  final FoodCategory category;
  final String element;

  const Food({
    required this.id,
    required this.name,
    required this.imageKey,
    required this.category,
    required this.element,
  });

  /// Create Food from Firestore document data and path
  /// 
  /// Path format: foods/{element}/{category}/{foodId}
  /// Document data: { name, imageKey }
  factory Food.fromMap(String id, Map<String, dynamic> data, String element, String category) {
    return Food(
      id: id,
      name: data['name'] ?? '',
      imageKey: data['imageKey'] ?? '',
      category: FoodCategoryExtension.fromString(category),
      element: element,
    );
  }

  /// Convert Food to Firestore document data
  /// 
  /// Only writes { name, imageKey } - element and category are in the path
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageKey': imageKey,
    };
  }

  /// Get the full Firestore path for this food
  String get firestorePath {
    return 'foods/$element/${category.value}/$id';
  }

  /// Check if this food is suitable for a specific element
  bool isSuitableFor(String element) {
    return this.element == element;
  }

  /// Get display name with proper capitalization
  String get displayName {
    if (name.isEmpty) return '';
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  String toString() {
    return 'Food(id: $id, name: $name, imageKey: $imageKey, category: $category, element: $element)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Food &&
        other.id == id &&
        other.name == name &&
        other.imageKey == imageKey &&
        other.category == category &&
        other.element == element;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        imageKey.hashCode ^
        category.hashCode ^
        element.hashCode;
  }
}
