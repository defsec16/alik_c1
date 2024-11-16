import 'package:alik_c1/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Hotel cards are displayed', (WidgetTester tester) async {
    final hotels = [
      Hotel(
        hotelId: 1,
        hotelName: 'The Alps\' Hotel',
        hotelRating: 4.5,
        hotelToSkiDistance: 2.3,
        hotelCoverImage: 'hotel_image.jpg',
      ),
    ];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            itemCount: hotels.length,
            itemBuilder: (context, index) {
              final hotel = hotels[index];
              return HotelCard(
                hotelName: hotel.hotelName,
                rating: hotel.hotelRating,
                distance: '${hotel.hotelToSkiDistance} km from Alps\' ski lift',
                imagePath: hotel.hotelCoverImage,
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('The Alps\' Hotel'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
    expect(find.text('2.3 km from Alps\' ski lift'), findsOneWidget);
  });
}
