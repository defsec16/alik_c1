import 'package:alik_c1/booking_confirm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alik_c1/review_model.dart';

void main() {
  // Мокаем данные комнаты для теста
  final room = Room(
    roomType: 'Deluxe Suite',
    bedType: 'King Size',
    totalGuests: 2,
    price: 100.0,
    roomFeatures: [],
  );

  // Тест на корректное отображение данных комнаты
  testWidgets('BookingConfirmPage displays room details correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingConfirmPage(room: room),
      ),
    );

    // Проверяем отображение информации о комнате
    expect(find.text('Room : Deluxe Suite'), findsOneWidget);
    expect(find.text('Bed : King Size'), findsOneWidget);
    expect(find.text('Total number of Guests : 2'), findsOneWidget);
    expect(find.text('€100.0'), findsOneWidget);
  });

  // Тест на правильную валидацию имени
  testWidgets('First name validation works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingConfirmPage(room: room),
      ),
    );

    // Ожидаем, что форма изначально не пройдет валидацию без ввода имени
    await tester.tap(find.byType(ElevatedButton)); // Нажимаем кнопку "Book Now"
    await tester.pump(); // Пытаемся обновить экран

    expect(find.text('Please enter your first name'), findsOneWidget);

    // Вводим правильное имя
    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.pump();

    expect(find.text('Please enter your first name'), findsNothing);
  });

  // Тест на расчет общей стоимости
  testWidgets('Total price is calculated correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingConfirmPage(room: room),
      ),
    );

    // Проверяем исходную стоимость
    expect(find.text('€100.0'), findsOneWidget);

    // Меняем количество взрослых
    await tester.enterText(find.byType(TextFormField).at(2), '2');
    await tester.pump();

    // Ожидаем, что стоимость увеличится
    expect(find.text('€200.0'), findsOneWidget);
  });

  // Тест на выбор даты заезда
  testWidgets('Check-in date picker works correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingConfirmPage(room: room),
      ),
    );

    // Нажимаем на поле выбора даты заезда
    await tester.tap(find.byType(TextFormField).at(3)); 
    await tester.pumpAndSettle(); // Дожидаемся загрузки DatePicker

    // Выбираем дату
    await tester.tap(find.text('15')); // Выбираем 15 число
    await tester.pump();

    // Проверяем, что дата отображается
    expect(find.text('2024-11-15'), findsOneWidget); // Замените на актуальную дату
  });

  // Тест на кнопку бронирования
  testWidgets('Booking button shows confirmation dialog', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingConfirmPage(room: room),
      ),
    );

    // Вводим необходимые данные
    await tester.enterText(find.byType(TextFormField).at(0), 'John');
    await tester.enterText(find.byType(TextFormField).at(1), 'Doe');
    await tester.enterText(find.byType(TextFormField).at(2), '1');
    await tester.enterText(find.byType(TextFormField).at(3), '2024-11-15');
    await tester.enterText(find.byType(TextFormField).at(4), '2024-11-16');
    await tester.pump();

    // Нажимаем на кнопку "Book Now"
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // Проверяем, что появился диалог с подтверждением
    expect(find.text('Booking Confirmed'), findsOneWidget);
    expect(find.text('Your booking has been confirmed!'), findsOneWidget);
  });

  // Тест на правильную работу радиокнопок для типа поездки
  testWidgets('Travel reason radio buttons work correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingConfirmPage(room: room),
      ),
    );

    // Проверяем, что по умолчанию выбрана опция "For sightseeing"
    expect(find.byWidgetPredicate(
      (widget) => widget is Radio && widget.groupValue == 'sightseeing',
    ), findsOneWidget);

    // Меняем тип поездки на "business"
    await tester.tap(find.byType(Radio).at(1));
    await tester.pump();

    // Проверяем, что тип поездки изменился на "business"
    expect(find.byWidgetPredicate(
      (widget) => widget is Radio && widget.groupValue == 'business',
    ), findsOneWidget);
  });

  // Тест на правильное отображение стоимости в зависимости от типа поездки
  testWidgets('Business trip adds extra cost', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BookingConfirmPage(room: room),
      ),
    );

    // Проверяем исходную стоимость
    expect(find.text('€100.0'), findsOneWidget);

    // Выбираем тип поездки "business"
    await tester.tap(find.byType(Radio).at(1)); // Выбираем бизнес-поездку
    await tester.pump();

    // Проверяем, что стоимость увеличилась на 150 евро
    expect(find.text('€250.0'), findsOneWidget);
  });
}
