import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lostnfound/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget); // Check for "0"
    expect(find.text('1'), findsNothing); // Ensure "1" is not present

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // Rebuild the widget after state change

    // Verify that our counter has incremented to 1.
    expect(find.text('0'), findsNothing); // Ensure "0" is no longer present
    expect(find.text('1'), findsOneWidget); // Check for "1"
  });
}
