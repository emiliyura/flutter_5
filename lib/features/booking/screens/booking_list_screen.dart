import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../booking/models/booking.dart';
import '../../booking/models/room.dart';
import '../../booking/models/app_data.dart';
import '../widgets/booking_item.dart';
import 'room_list_screen.dart';

class BookingListScreen extends StatefulWidget {
  const BookingListScreen({super.key});

  @override
  State<BookingListScreen> createState() => _BookingListScreenState();
}

class _BookingListScreenState extends State<BookingListScreen> {
  void _cancelBooking(String bookingId) {
    setState(() {
      AppData.cancelBooking(bookingId);
    });
  }

  void _navigateToRooms() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RoomListScreen(),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final bookings = AppData.bookings;
    final rooms = AppData.rooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои бронирования'),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: 'Номера',
            onPressed: _navigateToRooms,
            icon: const Icon(Icons.hotel),
          ),
        ],
      ),
      body: bookings.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(12.0),
              itemCount: bookings.length,
              itemBuilder: (context, idx) {
                final b = bookings[idx];
                final room = rooms.firstWhere(
                  (r) => r.id == b.roomId,
                  orElse: () => Room(id: 'x', title: 'Неизвестно', price: 0, beds: 0),
                );
                return BookingItem(
                  booking: b,
                  room: room,
                  onCancel: () => _cancelBooking(b.id),
                );
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Stack(
      children: [
        // Фоновое изображение
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmCa_Cmte1PJ3rwqu425kd3fyVAdmFqSBA7L6B0cjvVcAQr1AapPwU100OZT5tsiVrjts&usqp=CAU', //'''https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800&h=600&fit=crop',
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.hotel,
                  color: Colors.grey,
                  size: 80,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        // Контент поверх изображения
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.calendar_today,
                size: 80,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'Бронирований нет',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Забронируйте номер для отдыха',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}


