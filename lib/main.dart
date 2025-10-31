import 'package:flutter/material.dart';
import 'features/booking/page_navigation_container.dart';
//import 'features/booking/route_navigation_container.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ============================================
    // ВЫБЕРИТЕ РЕАЛИЗАЦИЮ НАВИГАЦИИ:
    // ============================================

    // КОММИТ 1: Страничная навигация (PageView)
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Booking App',
      theme: ThemeData(useMaterial3: true),
      home: const PageNavigationContainer(),
    );

    // КОММИТ 2: Маршрутизированная навигация (Named Routes)
    // return const RouteNavigationContainer();
  }
}