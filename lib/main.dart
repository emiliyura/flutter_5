import 'package:flutter/material.dart';
// import 'features/booking/page_navigation_container.dart';
import 'features/booking/route_navigation_container.dart';

void main() {
  runApp(const BookingApp());
}

class BookingApp extends StatelessWidget {
  const BookingApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const RouteNavigationContainer();
  }
}