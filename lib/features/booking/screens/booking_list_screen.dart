import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../booking/models/booking.dart';
import '../../booking/models/room.dart';
import '../widgets/booking_item.dart';

class BookingListScreen extends StatelessWidget {
  final List<Booking> bookings;
  final List<Room> rooms;
  final void Function(String bookingId) onCancelBooking;

  const BookingListScreen({Key? key, required this.bookings, required this.rooms, required this.onCancelBooking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text('Мои бронирования', style: Theme.of(context).textTheme.titleLarge),
          ),
        ),
        Expanded(
          child: bookings.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
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
                      onCancel: () => onCancelBooking(b.id),
                    );
                  },
                ),
        )
      ],
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


