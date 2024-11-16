// class Review {
//   final String username;
//   final String country;
//   final String reviewText;

//   Review({
//     required this.username,
//     required this.country,
//     required this.reviewText,
//   });

//   factory Review.fromJson(Map<String, dynamic> json) {
//     return Review(
//       username: json['username'],
//       country: json['country'],
//       reviewText: json['review_text'],
//     );
//   }
// }

// class Hotel {
//   final String name;
//   final Map<String, double> ratings;  // Рейтинги как Map
//   final List<Review> reviews;
//   final List<Room> rooms;
//   Hotel({
//     required this.name,
//     required this.ratings,
//     required this.reviews,
//     required this.rooms,
//   });

//   factory Hotel.fromJson(Map<String, dynamic> json) {
//     var ratings = <String, double>{};
//     for (var category in json['guest_reviews']['ratings_categories']) {
//       ratings[category.keys.first] = category.values.first;
//     }
//     return Hotel(
//       name: json['hotel_name'],
//       ratings: ratings,
//       reviews: (json['guest_reviews']['reviews_objects'] as List)
//           .map((review) => Review.fromJson(review))
//           .toList(),
//       rooms: (json['rooms'] as List)  // Извлекаем список номеров
//           .map((room) => Room.fromJson(room))
//           .toList(),
//     );
//   }
  
  
// }
// class Room {
//   final String roomType;
//   final String bedType;
//   final int totalGuests;
//   final List<String> roomFeatures;
//   final double price;

//   Room({
//     required this.roomType,
//     required this.bedType,
//     required this.totalGuests,
//     required this.roomFeatures,
//     required this.price,
//   });

//   // Отображение из JSON
//   factory Room.fromJson(Map<String, dynamic> json) {
//     return Room(
//       roomType: json['room_type'],
//       bedType: json['room_bed_type'],
//       totalGuests: json['room_total_number_of_guests'],
//       roomFeatures: List<String>.from(json['room_features']),
//       price: json['room_price_for_one_night'].toDouble(),
//     );
//   }
// }
class Review {
  final String username;
  final String country;
  final String reviewText;

  Review({
    required this.username,
    required this.country,
    required this.reviewText,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['username'] ?? 'Unknown',  // Защита от отсутствующих ключей
      country: json['country'] ?? 'Unknown',
      reviewText: json['review_text'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'country': country,
      'review_text': reviewText,
    };
  }
}

class Hotel {
  final String name;
  final Map<String, double> ratings;
  final List<Review> reviews;
  final List<Room> rooms;

  Hotel({
    required this.name,
    required this.ratings,
    required this.reviews,
    required this.rooms,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    var ratings = <String, double>{};
    if (json['guest_reviews'] != null && json['guest_reviews']['ratings_categories'] != null) {
      for (var category in json['guest_reviews']['ratings_categories']) {
        if (category.isNotEmpty) {
          var key = category.keys.first;
          ratings[key] = category[key]?.toDouble() ?? 0.0;
        }
      }
    }
    
    return Hotel(
      name: json['hotel_name'] ?? 'Unknown Hotel', // Защита от отсутствующих ключей
      ratings: ratings,
      reviews: (json['guest_reviews']['reviews_objects'] as List?)
              ?.map((review) => Review.fromJson(review))
              .toList() ?? [],
      rooms: (json['rooms'] as List?)
              ?.map((room) => Room.fromJson(room))
              .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hotel_name': name,
      'guest_reviews': {
        'ratings_categories': ratings.entries.map((entry) => {entry.key: entry.value}).toList(),
        'reviews_objects': reviews.map((review) => review.toJson()).toList(),
      },
      'rooms': rooms.map((room) => room.toJson()).toList(),
    };
  }
}

class Room {
  final String roomType;
  final String bedType;
  final int totalGuests;
  final List<String> roomFeatures;
  final double price;

  Room({
    required this.roomType,
    required this.bedType,
    required this.totalGuests,
    required this.roomFeatures,
    required this.price,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomType: json['room_type'] ?? 'Unknown Type',  // Защита от отсутствующих ключей
      bedType: json['room_bed_type'] ?? 'Unknown Bed Type',
      totalGuests: json['room_total_number_of_guests'] ?? 0,
      roomFeatures: List<String>.from(json['room_features'] ?? []),
      price: (json['room_price_for_one_night']?.toDouble()) ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'room_type': roomType,
      'room_bed_type': bedType,
      'room_total_number_of_guests': totalGuests,
      'room_features': roomFeatures,
      'room_price_for_one_night': price,
    };
  }
}
