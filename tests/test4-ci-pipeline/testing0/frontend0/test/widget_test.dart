import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend0/main.dart';

void main() {
  testWidgets('Counter increments when button is tapped', (WidgetTester tester) async {
    // Arrange: Set up the widget
    await tester.pumpWidget(const MaterialApp(home: CounterPage()));
    
    // Verify initial state
    expect(find.text('0'), findsOneWidget);
    
    // Act: Tap the button (this calls _incrementCounter())
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(); // Trigger state update after tap
    
    // Assert: Counter should have incremented from 0 to 1
    expect(find.text('1'), findsOneWidget);
    expect(find.text('0'), findsNothing);
  });
}

