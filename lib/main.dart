import 'package:flutter/material.dart';
import 'package:flutter_5/app/app_router.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Booking App',
      theme: ThemeData(useMaterial3: true),
      routerConfig: appRouter,
    );
  }
}