import 'package:alik_c1/booking_detail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('ReviewCard displays review data correctly', (WidgetTester tester) async {
    // Создаем объект отзыва
    final review = ReviewCard(
      name: 'John Doe',
      country: 'USA',
      reviewText: 'Great stay!',
    );

    // Строим виджет для теста
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(body: review),
    ));

    // Проверяем, что имя, страна и текст отзыва отображаются
    expect(find.text('John Doe'), findsOneWidget);
    expect(find.text('USA'), findsOneWidget);
    expect(find.text('Great stay!'), findsOneWidget);
  });
}
