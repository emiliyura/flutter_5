import 'package:flutter/material.dart';
import '../../booking/models/booking.dart';
import '../../booking/models/room.dart';
import '../widgets/booking_item.dart';

class BookingListScreen extends StatelessWidget {
  final List<Booking> bookings;
  final List<Room> rooms;
  final void Function(String bookingId) onCancelBooking;
  final VoidCallback onBack;

  const BookingListScreen({Key? key, required this.bookings, required this.rooms, required this.onCancelBooking, required this.onBack}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back)),
              Expanded(child: Text('Мои бронирования', style: Theme.of(context).textTheme.titleLarge)),
            ],
          ),
        ),
        Expanded(
          child: bookings.isEmpty
              ? const Center(child: Text('Бронирований нет'))
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
}


