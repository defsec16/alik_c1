import 'package:alik_c1/booking_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('BookingDetailsPage displays loading indicator', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BookingDetailsPage(),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('BookingDetailsPage displays error message when data loading fails', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BookingDetailsPage(),
    ));

    await tester.pumpAndSettle();
    
    expect(find.text('Error loading data'), findsOneWidget);
  });

  testWidgets('BookingDetailsPage shows data when data is loaded', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: BookingDetailsPage(),
    ));

    expect(find.text('Some Hotel Name'), findsOneWidget); 
  });
}
