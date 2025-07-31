// This is a basic Flutter widget test for Aura app.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:aura/main.dart';

void main() {
  testWidgets('Aura app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const AuraApp());

    // Verify that the app builds without errors
    // This is a basic smoke test to ensure the app can be instantiated
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
