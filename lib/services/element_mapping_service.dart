import 'package:cloud_firestore/cloud_firestore.dart';

/// Service for handling day-to-element mapping and element derivation
class ElementMappingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch the day-to-element mapping from Firestore
  /// Returns a map where keys are lowercase day names and values are elements
  Future<Map<String, String>> fetchDayElementMapping() async {
    final doc = await _firestore
        .collection('config')
        .doc('dayElementMapping')
        .get();
    if (!doc.exists) {
      throw Exception('Day-element mapping document is missing.');
    }
    final data = Map<String, dynamic>.from(doc.data() ?? {});
    // Expect 7 keys: sunday..saturday (lowercase)
    const expected = ['sunday','monday','tuesday','wednesday','thursday','friday','saturday'];
    for (final k in expected) {
      if (!data.containsKey(k) || (data[k] is! String)) {
        throw Exception('Mapping key "$k" missing or invalid.');
      }
    }
    return data.map((k, v) => MapEntry(k.toString().toLowerCase().trim(), v.toString().trim()));
  }

  /// Get the day of week as a string from a DateTime
  /// Uses local timezone calculation as specified in requirements
  String _weekdayName(DateTime dob) {
    // 1=Mon..7=Sun
    final names = ['Monday','Tuesday','Wednesday','Thursday','Friday','Saturday','Sunday'];
    final idx = dob.weekday; // 1..7
    return names[idx - 1];
  }

  /// Convert string to title case
  String _titleCase(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1).toLowerCase();

  /// Derive the day of week and element from a given date of birth
  /// Returns a record with dayOfWeek and element
  Future<({String dayOfWeek, String element})> deriveForDob(DateTime dob) async {
    final mapping = await fetchDayElementMapping();
    final dayName = _weekdayName(dob);         // e.g., "Friday"
    final key = dayName.toLowerCase();         // "friday"
    final element = mapping[key];
    if (element == null || element.isEmpty) {
      throw Exception('No element found for "$dayName".');
    }
    return (dayOfWeek: dayName, element: _titleCase(element));
  }

  /// Seed the day element mapping document in Firestore
  /// This is a helper method for initial setup (can be called from debug button)
  Future<void> seedDayElementMapping() async {
    try {
      final mapping = {
        'sunday': 'Fire',
        'monday': 'Earth',
        'tuesday': 'Wind',
        'wednesday': 'Water',
        'thursday': 'Earth',
        'friday': 'Water',
        'saturday': 'Fire',
      };

      await _firestore
          .collection('config')
          .doc('dayElementMapping')
          .set(mapping);

      print('Day element mapping seeded successfully');
    } catch (e) {
      print('Failed to seed day element mapping: $e');
      rethrow;
    }
  }
}
