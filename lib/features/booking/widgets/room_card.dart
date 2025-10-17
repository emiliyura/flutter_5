import 'package:flutter/material.dart';
import '../../booking/models/room.dart';

class RoomCard extends StatelessWidget {
  final Room room;
  final ValueChanged<Room> onBook;

  const RoomCard({Key? key, required this.room, required this.onBook}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(room.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text('Мест: ${room.beds} • ${room.amenities.join(', ')}'),
                  const SizedBox(height: 6),
                  Text('Цена: \$${room.price.toStringAsFixed(2)}/сут', style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Column(
              children: [
                room.isBooked
                    ? Chip(label: const Text('Забронирован'), backgroundColor: Colors.red.shade100)
                    : ElevatedButton(onPressed: () => onBook(room), child: const Text('Забронировать')),
                const SizedBox(height: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
}


