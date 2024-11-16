import 'package:alik_c1/booking_detail.dart';
import 'package:alik_c1/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alik_c1/main.dart';

void main() {
  testWidgets('Full flow test for HomeScreen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();

    expect(find.byType(HotelCard), findsWidgets);

    await tester.tap(find.text('Book it'));
    await tester.pumpAndSettle();

    expect(find.byType(BookingDetailsPage), findsOneWidget);
  });
}
