import 'dart:convert';

import 'package:alik_c1/booking_confirm.dart';
import 'package:alik_c1/review_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BookingDetailsPage extends StatefulWidget {
  const BookingDetailsPage({Key? key}) : super(key: key);

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedHotel = ''; 
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); 
  }
  Future<Map<String, dynamic>> loadHotelData() async {
    String fileName = '';
    
    if (selectedHotel == 'Résidence Pierre & Vacances Premium les Crets') {
      fileName = 'assets/hotels_details.1000.json';
    } else if (selectedHotel == 'Appartement Méribel') {
      fileName = 'assets/hotels_details.1008.json';
    } else {
      fileName = 'assets/hotels_details.1000.json'; // Стандартный файл, если отель не выбран
    }
    
    final String response = await rootBundle.loadString(fileName);
    return json.decode(response);
  }
  

  Future<Hotel> fetchHotelData() async {
    final data = await loadHotelData();
    return Hotel.fromJson(data);  
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => (Navigator.pop(context)),
        ),
        title: Text('Booking'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: "Guest Reviews"),
            Tab(text: "Room Selection"),
          ],
        ),
      ),
      body: FutureBuilder<Hotel>(
        future: fetchHotelData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading data'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No data found'));
          }

          final hotel = snapshot.data!;

          return TabBarView(
            controller: _tabController,
            children: [
              _buildGuestReviews(hotel), // Экран для отзывов
              _buildRoomSelection(hotel), // Экран для выбора номера
            ],
          );
        },
      ),
    );
  }
Widget _buildGuestReviews(Hotel hotel) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.center, // Выравнивание по центру
              child: Text(
                hotel.name, // Используем данные из JSON
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ratings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                _buildRatingRow('Location', hotel.ratings['Location'] ?? 0),
                SizedBox(height: 8),
                _buildRatingRow('Staff', hotel.ratings['Staff'] ?? 0),
                SizedBox(height: 8),
                _buildRatingRow('Value for money', hotel.ratings['Value for money'] ?? 0),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reviews',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: hotel.reviews.map((review) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: ReviewCard(
                          name: review.username,
                          country: review.country,
                          reviewText: review.reviewText,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
Widget _buildRoomSelection(Hotel hotel) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.center, // Выравнивание по центру
            child: Text(
              hotel.name, // Используем данные из JSON
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Rooms',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true, // Чтобы не растягивать на весь экран
          itemCount: hotel.rooms.length,
          itemBuilder: (context, index) {
            final room = hotel.rooms[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Stack(
                children: [
                  ListTile(
                    title: Text(room.roomType),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bed: ${room.bedType}'),
                        Text('Total number of guests: ${room.totalGuests}'),
                        Text("${room.roomFeatures}")
                      ],
                    ),
                    onTap: () {
                      // Навигация на экран подтверждения бронирования
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookingConfirmPage(room: room),
                        ),
                      );
                    },
                  ),
                  // Цена в правом нижнем углу
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Row(
                      children: [
                        Icon(Icons.euro, size: 18),
                        Text(
                          '${room.price}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    ),
  );
}


 Widget _buildRatingRow(String title, double rating) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        Column(
          children: [
            Text(rating.toString()),
            SizedBox(height: 8),
            Container(
              width: 200,
              child: LinearProgressIndicator(
                value: rating / 10, // Предполагаем, что максимальный рейтинг — 5
                backgroundColor: Colors.grey[300],
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ],
    );
  }

}
class ReviewCard extends StatelessWidget {
  final String name;
  final String country;
  final String reviewText;

  const ReviewCard({
    Key? key,
    required this.name,
    required this.country,
    required this.reviewText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
      ),
      height: 260,
      width: 230,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey[300],
                child: Text(
                  name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    country,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              reviewText,
              
              style: const TextStyle(
                fontSize: 14,
              ),
              overflow: TextOverflow.visible, 
              softWrap: true, 
            ),
          ),
        ],
      ),
    );
  }
}

