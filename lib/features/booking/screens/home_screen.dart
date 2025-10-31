import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onShowRooms;
  final VoidCallback onShowBookings;
  final VoidCallback onShowProfile;
  final VoidCallback onShowSettings;

  const HomeScreen({
    Key? key,
    required this.onShowRooms,
    required this.onShowBookings,
    required this.onShowProfile,
    required this.onShowSettings,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Главная', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: onShowRooms,
              child: const Text('Номера'),
            ),
            ElevatedButton(
              onPressed: onShowBookings,
              child: const Text('Бронирования'),
            ),
          ],
        ),
      ),
    );
  }
}