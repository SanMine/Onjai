// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:oonjai/main.dart';

void main() {
  testWidgets('Oonjai app smoke test', (WidgetTester tester) async {
    // Build our app with a test child to avoid Firebase dependencies
    await tester.pumpWidget(const OonjaiApp(
      testChild: Scaffold(
        body: Center(
          child: Text('Test Home'),
        ),
      ),
    ));

    // Verify that the app loads without errors
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Test Home'), findsOneWidget);
  });
}
