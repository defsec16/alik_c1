import 'package:alik_c1/review_model.dart';
import 'package:flutter/material.dart';

class BookingConfirmPage extends StatefulWidget {
  final Room room;

  const BookingConfirmPage({Key? key, required this.room}) : super(key: key);

  @override
  _BookingConfirmPageState createState() => _BookingConfirmPageState();
}

class _BookingConfirmPageState extends State<BookingConfirmPage> {
  final _formKey = GlobalKey<FormState>();

  // Form data
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _adultsController = TextEditingController(text: '1');
  final TextEditingController _childrenController = TextEditingController(text: '0');

  DateTime? checkInDate;
  DateTime? checkOutDate;
  String travelReason = 'sightseeing';
  String paymentMethod = 'cash';

  double totalPrice = 0.0;

  // Calculate total price based on options
void _calculateTotalPrice() {
  // Parse the adults and children values and handle null safely
  int adults = int.tryParse(_adultsController.text) ?? 1;
  int children = int.tryParse(_childrenController.text) ?? 0;

  double price = widget.room.price * (adults + children);

  // If it's a business trip, add additional costs
  if (travelReason == 'business') {
    price += 150; // Add €150 for business travel with a meeting room
  }

  totalPrice = price;
}

  @override
  Widget build(BuildContext context) {
    // Calculate the total price every time the form changes
    _calculateTotalPrice();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Booking Confirm'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You are going to reserve:', style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              Text('Room : ${widget.room.roomType}', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              Text('Bed : ${widget.room.bedType}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,  // Выравнивание по краям
                children: [
                  Text('Total number of Guests : ${widget.room.totalGuests}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('€${widget.room.price}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
              SizedBox(height: 20),
              Text('Form', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First Name and Last Name
                    TextFormField(
                      controller: _firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your first name';
                        }
                        // Регулярное выражение для проверки, что введены только буквы
                        if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(value)) {
                          return 'Please enter a valid name (letters only)';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your last name';
                        }
                        // Регулярное выражение для проверки, что введены только буквы
                        if (!RegExp(r'^[a-zA-Zа-яА-Я]+$').hasMatch(value)) {
                          return 'Please enter a valid last name (letters only)';
                        }
                        return null;
                      },
                    ),
                    // Check-in and Check-out Dates
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: checkInDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(() {
                                  checkInDate = picked;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Check-in Date'),
                                controller: TextEditingController(
                                  text: checkInDate != null
                                      ? '${checkInDate!.toLocal()}'.split(' ')[0]
                                      : '',
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: checkOutDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null) {
                                setState(() {
                                  checkOutDate = picked;
                                });
                              }
                            },
                            child: AbsorbPointer(
                              child: TextFormField(
                                decoration: InputDecoration(labelText: 'Check-out Date'),
                                controller: TextEditingController(
                                  text: checkOutDate != null
                                      ? '${checkOutDate!.toLocal()}'.split(' ')[0]
                                      : '',
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Adults and Children
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _adultsController,
                            decoration: InputDecoration(labelText: 'Adults'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              int? adults = int.tryParse(value ?? '');
                              if (adults == null || adults < 1 || adults > 5) {
                                return 'Please enter a valid number of Adults (от 1 до 5)';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              int? adults = int.tryParse(value);
                              if (adults != null) {
                                setState(() {
                                  _childrenController.text = '0'; // Сбрасываем количество детей на 0 при изменении взрослых
                                });
                              }
                            },
                          ),
                        ),
                        SizedBox(width: 20),
                        Expanded(
                          child: TextFormField(
                            controller: _childrenController,
                            decoration: InputDecoration(labelText: 'Children'),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              int? children = int.tryParse(value ?? '');
                              int adults = int.tryParse(_adultsController.text) ?? 1;
                              if (children == null || children < 0 || children > (adults * 2)) {
                                return 'Please enter a valid number of children';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Travel for business?'),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'sightseeing',
                          groupValue: travelReason,
                          onChanged: (value) {
                            setState(() {
                              travelReason = value!;
                            });
                          },
                        ),
                        Text('For sightseeing'),
                        Radio<String>(
                          value: 'business',
                          groupValue: travelReason,
                          onChanged: (value) {
                            setState(() {
                              travelReason = value!;
                            });
                          },
                        ),
                        Text('+ €150\n For business \nwith a meeting room'),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text('Which way to pay?'),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'cash',
                          groupValue: paymentMethod,
                          onChanged: (value) {
                            setState(() {
                              paymentMethod = value!;
                            });
                          },
                        ),
                        Text('Cash'),
                        Radio<String>(
                          value: 'credit_card',
                          groupValue: paymentMethod,
                          onChanged: (value) {
                            setState(() {
                              paymentMethod = value!;
                            });
                          },
                        ),
                        Text('Credit Card'),
                        Radio<String>(
                          value: 'e_pay',
                          groupValue: paymentMethod,
                          onChanged: (value) {
                            setState(() {
                              paymentMethod = value!;
                            });
                          },
                        ),
                        Text('E-Pay'),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Price Display
                    Row(
                      children: [
                        Spacer(),  // This will ensure that the price is aligned to the right
                        Text(
                          '€${totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    // Book Now Button
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Booking Confirmed'),
                                content: Text('Your booking has been confirmed!'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),  
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30), 
                          ),
                          textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),  
                          backgroundColor: Colors.green, 
                          foregroundColor: Colors.white, 
                        ),
                        child: Text('Book Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}