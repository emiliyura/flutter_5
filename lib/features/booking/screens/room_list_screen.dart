import 'package:flutter/material.dart';
import '../../booking/models/room.dart';
import '../widgets/room_card.dart';

class RoomListScreen extends StatelessWidget {
  final List<Room> rooms;
  final ValueChanged<Room> onBook;
  final VoidCallback onOpenBookings;

  const RoomListScreen({Key? key, required this.rooms, required this.onBook, required this.onOpenBookings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(child: Text('Доступные номера', style: Theme.of(context).textTheme.titleLarge)),
              ElevatedButton.icon(onPressed: onOpenBookings, icon: const Icon(Icons.list), label: const Text('Мои брони'))
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final r = rooms[index];
              return RoomCard(room: r, onBook: onBook);
            },
          ),
        ),
      ],
    );
  }
}


