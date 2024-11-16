import 'package:flutter/material.dart';

class MyBookingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context); // Go back to the previous screen
          },
        ),
        title: Text('My Bookings'),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: SingleChildScrollView(  // Добавляем прокрутку
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'List of my bookings',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            BookingCard(
              number: 1,
              hotelName: 'John Doe',
              hotelDetails: 'Tue, Sep 10, 2024 to Sun, Sep 15, 2024\n2 Adults, 0 Children, 1 Room\nFor sightseeing. Pay with cash',
              price: '299',
            ),
            SizedBox(height: 10),
            BookingCard(
              number: 2,
              hotelName: 'Jane Smith',
              hotelDetails: 'Tue, Sep 10, 2024 to Sun, Sep 15, 2024\n2 Adults, 0 Children, 1 Room\nFor sightseeing. Pay with cash',
              price: '299',
            ),
            SizedBox(height: 10),
            BookingCard(
              number: 3,
              hotelName: 'Alice Johnson',
              hotelDetails: 'Tue, Sep 10, 2024 to Sun, Sep 15, 2024\n2 Adults, 0 Children, 1 Room\nFor sightseeing. Pay with cash',
              price: '299',
            ),
            SizedBox(height: 10),
            BookingCard(
              number: 4,
              hotelName: 'Robert Brown',
              hotelDetails: 'Tue, Sep 10, 2024 to Sun, Sep 15, 2024\n2 Adults, 0 Children, 1 Room\nFor sightseeing. Pay with cash',
              price: '299',
            ),
            SizedBox(height: 10),
            BookingCard(
              number: 5,
              hotelName: 'Emily White',
              hotelDetails: 'Tue, Sep 10, 2024 to Sun, Sep 15, 2024\n2 Adults, 0 Children, 1 Room\nFor sightseeing. Pay with cash',
              price: '299',
            ),
            // Можно добавить больше карточек бронирования
          ],
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final int number;
  final String hotelName;
  final String hotelDetails;
  final String price;

  BookingCard({
    required this.number,
    required this.hotelName,
    required this.hotelDetails,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(  // Используем Row для выравнивания нумерации и текста
          children: [
            Text(
              '$number',  // Нумерация слева
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,  // Цвет нумерации
              ),
            ),
            SizedBox(width: 16),  // Отступ между номером и текстом
            Expanded(  // Чтобы остальная часть карточки занимала доступное пространство
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    hotelName,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    hotelDetails,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  
                ],
              ),
            ),
            Text(
                    '€$price',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
