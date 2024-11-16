import 'package:alik_c1/my_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MyBookingsPage has correct widgets and booking details', (WidgetTester tester) async {
    // Build the MyBookingsPage widget
    await tester.pumpWidget(MaterialApp(
      home: MyBookingsPage(),
    ));

    // Allow widgets to settle
    await tester.pumpAndSettle();

    // Verify if the AppBar is present
    expect(find.byType(AppBar), findsOneWidget);

    // Verify if the title of the AppBar is 'My Bookings'
    expect(find.text('My Bookings'), findsOneWidget);

    // Verify the presence of the text 'List of my bookings'
    expect(find.text('List of my bookings'), findsOneWidget);

    // Verify the number of BookingCard widgets
    expect(find.byType(BookingCard), findsNWidgets(5));

    // Verify that the price is displayed correctly for each booking
    expect(find.text('€299'), findsNWidgets(5));

    // Check if the booking details are visible (use textContaining if the exact text varies)
    expect(find.textContaining('Tue, Sep 10, 2024 to Sun, Sep 15, 2024'), findsNWidgets(5));

    // Verify if the back button is present in the AppBar
    expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
  });

  testWidgets('Tapping the back button navigates back', (WidgetTester tester) async {
    // Build the MyBookingsPage widget
    await tester.pumpWidget(MaterialApp(
      home: MyBookingsPage(),
    ));

    // Allow widgets to settle
    await tester.pumpAndSettle();

    // Tap the back button
    await tester.tap(find.byIcon(Icons.arrow_back_ios));
    await tester.pumpAndSettle(); // Allow navigation animation to complete

    // Check if we are back at the previous screen (you can check specific widget presence on the previous screen)
    // Example: Check if a specific widget from the previous screen is visible
    // expect(find.text('Previous Screen'), findsOneWidget);
  });
}
