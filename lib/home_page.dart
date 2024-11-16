import 'dart:convert';

import 'package:alik_c1/booking_detail.dart';
import 'package:alik_c1/my_booking.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => __HomeScreenStateState();
}

class __HomeScreenStateState extends State<HomeScreen> {

  List<Hotel> hotels = [];

  @override
  void initState() {
    super.initState();
    loadHotelsFromJson();
  }
  Future<void> loadHotelsFromJson() async {
    // Загрузка JSON из файла
    final String response = await rootBundle.loadString('assets/hotels.json');
    final List<dynamic> data = json.decode(response);

    setState(() {
      hotels = data.map((hotel) => Hotel.fromJson(hotel)).toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('The Alps\' Hotel'),
            const SizedBox(width: 10),
            Image.asset('assets/france_national_flag.png', height: 20),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_4_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  MyBookingsPage(), // Укажите вашу страницу
                ),
              );
            },
          ),
        ],
      ),
      body: hotels.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
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
    );
  }
}

class Hotel {
  final int hotelId;
  final String hotelName;
  final double hotelRating;
  final double hotelToSkiDistance;
  final String hotelCoverImage;

  Hotel({
    required this.hotelId,
    required this.hotelName,
    required this.hotelRating,
    required this.hotelToSkiDistance,
    required this.hotelCoverImage,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      hotelId: json['hotel_id'],
      hotelName: json['hotel_name'],
      hotelRating: json['hotel_rating'].toDouble(),
      hotelToSkiDistance: json['hotel_to_ski_distance'].toDouble(),
      hotelCoverImage: json['hotel_cover_image'],
    );
  }
}

class HotelCard extends StatelessWidget {
  final String hotelName;
  final double rating;
  final String distance;
  final String imagePath;

  const HotelCard({
    Key? key,
    required this.hotelName,
    required this.rating,
    required this.distance,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 80,
              width: 80,
              child: Image.asset(
                // imagePath,
                'assets/${imagePath}', 
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.image_not_supported, size: 60),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Row(
                        children: List.generate(
                          5,
                          (index) => Icon(
                            index < rating.round()
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(distance),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingDetailsPage()
                  ),
                );
              },
              child: const Text('Book it'),
            ),
          ],
        ),
      ),
    );
  }
}