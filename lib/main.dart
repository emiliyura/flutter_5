import 'package:flutter/material.dart';
import 'package:flutter_5/features/booking/screens/home_screen.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking App',
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}