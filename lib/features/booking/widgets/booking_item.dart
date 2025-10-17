import 'package:flutter/material.dart';
import '../../booking/models/booking.dart';
import '../../booking/models/room.dart';
import '../../../utils/formatters.dart';

class BookingItem extends StatelessWidget {
  final Booking booking;
  final Room room;
  final VoidCallback onCancel;

  const BookingItem({Key? key, required this.booking, required this.room, required this.onCancel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: ListTile(
        title: Text(room.title),
        subtitle: Text('${booking.guestName} • ${Formatters.formatDate(booking.checkIn)} — ${Formatters.formatDate(booking.checkOut)}'),
        trailing: TextButton(onPressed: onCancel, child: const Text('Отменить')),
      ),
    );
  }
}


