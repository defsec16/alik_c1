import 'package:alik_c1/booking_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alik_c1/review_model.dart'; // Assuming `Room` class and related classes are in this file

void main() {
  testWidgets('BookingConfirmPage form validation and price calculation', (WidgetTester tester) async {
    // Setup Room object for testing
    final testRoom = Room(
      roomType: 'Single',
      bedType: 'King',
      price: 100.0,
      totalGuests: 2,
      roomFeatures: []
    );

    // Build the widget
    await tester.pumpWidget(MaterialApp(
      home: BookingConfirmPage(room: testRoom),
    ));

    // Verify that the page loads correctly
    expect(find.text('Room : Single'), findsOneWidget);
    expect(find.text('Bed : King'), findsOneWidget);

    // Test default price is correct
    expect(find.text('€100.00'), findsOneWidget);

    // Test form validation
    await tester.tap(find.byType(ElevatedButton)); // Tap 'Book Now' button
    await tester.pump(); // Rebuild widget

    // Verify validation messages
    expect(find.text('Please enter your first name'), findsOneWidget);
    expect(find.text('Please enter your last name'), findsOneWidget);

    // Fill in valid data
    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), '2');
    await tester.enterText(find.byType(TextFormField).at(3), '1');

    // Tap the 'Book Now' button again
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump();

    // Verify no validation errors after entering valid data
    expect(find.text('Please enter your first name'), findsNothing);
    expect(find.text('Please enter your last name'), findsNothing);

    // Test total price calculation with valid inputs
    expect(find.text('€300.00'), findsOneWidget); // 100 * 2 (adults) + 100 * 1 (children)

    // Test if the booking confirmation dialog appears
    expect(find.text('Booking Confirmed'), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pump();
    expect(find.text('Booking Confirmed'), findsNothing);
  });

  testWidgets('Test for radio button selection and total price update', (WidgetTester tester) async {
    final testRoom = Room(
      roomType: 'Double',
      bedType: 'Queen',
      price: 150.0,
      totalGuests: 2,
      roomFeatures: []
    );

    await tester.pumpWidget(MaterialApp(
      home: BookingConfirmPage(room: testRoom),
    ));

    // Test if business travel option adds extra cost
    await tester.tap(find.byWidgetPredicate((widget) =>
        widget is Radio && widget.value == 'business'));
    await tester.pump();

    // Check that the total price is updated (150 + 150 for business travel)
    expect(find.text('€450.00'), findsOneWidget);

    // Test cash payment option selection
    await tester.tap(find.byWidgetPredicate((widget) =>
        widget is Radio && widget.value == 'credit_card'));
    await tester.pump();

    // Ensure the selected payment method is updated correctly
    expect(find.text('Credit Card'), findsOneWidget);
  });

  testWidgets('Test date selection', (WidgetTester tester) async {
    final testRoom = Room(
      roomType: 'Suite',
      bedType: 'King',
      price: 200.0,
      totalGuests: 2,
      roomFeatures: []
    );

    await tester.pumpWidget(MaterialApp(
      home: BookingConfirmPage(room: testRoom),
    ));

    // Open the check-in date picker and select a date
    await tester.tap(find.byType(TextFormField).at(0)); // Check-in date
    await tester.pumpAndSettle();
    await tester.tap(find.text('15').last); // Select a specific day
    await tester.pump();

    // Verify that the date is selected
    expect(find.text('2024-11-15'), findsOneWidget);

    // Open the check-out date picker and select a date
    await tester.tap(find.byType(TextFormField).at(1)); // Check-out date
    await tester.pumpAndSettle();
    await tester.tap(find.text('20').last); // Select a specific day
    await tester.pump();

    // Verify that the date is selected
    expect(find.text('2024-11-20'), findsOneWidget);
  });
}
