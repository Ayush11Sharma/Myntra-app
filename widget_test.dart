import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mintra/main.dart'; // make sure this matches your pubspec.yaml name

void main() {
  testWidgets('MyntraApp UI loads correctly', (WidgetTester tester) async {
    // Build the app
    await tester.pumpWidget(const MyntraApp());

    // ✅ Verify AppBar title exists
    expect(find.text('Myntra'), findsOneWidget);

    // ✅ Verify search icon is present
    expect(find.byIcon(Icons.search), findsOneWidget);

    // ✅ Verify banner section text
    expect(find.text('Banners Section'), findsOneWidget);

    // ✅ Verify category section text
    expect(find.text('Category Section'), findsOneWidget);

    // ✅ Verify brand section text
    expect(find.text('CONTINUE BROWSING THESE BRANDS'), findsOneWidget);
  });
}
