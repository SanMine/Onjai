/// Model for element-specific content (posters, symptom text, etc.)
class ElementContent {
  final String element;
  final String dashboardPosterKey;
  final String travelPosterKey;
  final String selfCarePosterKey;
  final String symptomText;

  const ElementContent({
    required this.element,
    required this.dashboardPosterKey,
    required this.travelPosterKey,
    required this.selfCarePosterKey,
    required this.symptomText,
  });

  /// Create ElementContent from Firestore document data
  factory ElementContent.fromMap(String element, Map<String, dynamic> data) {
    return ElementContent(
      element: element,
      dashboardPosterKey: data['dashboardPosterKey'] ?? '',
      travelPosterKey: data['travelPosterKey'] ?? '',
      selfCarePosterKey: data['selfCarePosterKey'] ?? '',
      symptomText: data['symptomText'] ?? '',
    );
  }

  /// Convert ElementContent to Firestore document data
  Map<String, dynamic> toMap() {
    return {
      'dashboardPosterKey': dashboardPosterKey,
      'travelPosterKey': travelPosterKey,
      'selfCarePosterKey': selfCarePosterKey,
      'symptomText': symptomText,
    };
  }

  /// Check if all poster keys are available
  bool get hasPosters {
    return dashboardPosterKey.isNotEmpty &&
           travelPosterKey.isNotEmpty &&
           selfCarePosterKey.isNotEmpty;
  }

  /// Check if symptom text is available
  bool get hasSymptomText {
    return symptomText.isNotEmpty;
  }

  @override
  String toString() {
    return 'ElementContent(element: $element, dashboardPosterKey: $dashboardPosterKey, travelPosterKey: $travelPosterKey, selfCarePosterKey: $selfCarePosterKey, symptomText: $symptomText)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ElementContent &&
        other.element == element &&
        other.dashboardPosterKey == dashboardPosterKey &&
        other.travelPosterKey == travelPosterKey &&
        other.selfCarePosterKey == selfCarePosterKey &&
        other.symptomText == symptomText;
  }

  @override
  int get hashCode {
    return element.hashCode ^
        dashboardPosterKey.hashCode ^
        travelPosterKey.hashCode ^
        selfCarePosterKey.hashCode ^
        symptomText.hashCode;
  }
}
