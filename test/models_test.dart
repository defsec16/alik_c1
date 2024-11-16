import 'dart:convert';

import 'package:alik_c1/review_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Review.fromJson should correctly parse JSON', () {
    // Пример JSON объекта для Review
    const jsonResponse = '''
      {
        "username": "john_doe",
        "country": "USA",
        "review_text": "Great hotel!"
      }
    ''';

    final Map<String, dynamic> json = jsonDecode(jsonResponse);

    final review = Review.fromJson(json);

    expect(review.username, 'john_doe');
    expect(review.country, 'USA');
    expect(review.reviewText, 'Great hotel!');
  });

  test('Hotel.fromJson should correctly parse JSON', () {
    // Пример JSON объекта для Hotel
    const jsonResponse = '''
      {
        "hotel_name": "Alps Hotel",
        "guest_reviews": {
          "ratings_categories": [
            {"cleanliness": 4.5},
            {"service": 4.2}
          ],
          "reviews_objects": [
            {
              "username": "john_doe",
              "country": "USA",
              "review_text": "Great hotel!"
            }
          ]
        },
        "rooms": [
          {
            "room_type": "Double",
            "room_bed_type": "King",
            "room_total_number_of_guests": 2,
            "room_features": ["WiFi", "AC"],
            "room_price_for_one_night": 150.0
          }
        ]
      }
    ''';

    final Map<String, dynamic> json = jsonDecode(jsonResponse);

    final hotel = Hotel.fromJson(json);

    expect(hotel.name, 'Alps Hotel');
    expect(hotel.ratings['cleanliness'], 4.5);
    expect(hotel.reviews.length, 1);
    expect(hotel.rooms.length, 1);
    expect(hotel.rooms.first.roomType, 'Double');
  });
}
