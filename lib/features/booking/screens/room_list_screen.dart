import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../booking/models/room.dart';
import '../../booking/models/app_data.dart';
import '../widgets/room_card.dart';

class RoomListScreen extends StatefulWidget {
  const RoomListScreen({super.key});

  @override
  State<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends State<RoomListScreen> {
  bool _priceAsc = true;

  void _toggleSort() {
    setState(() {
      _priceAsc = !_priceAsc;
    });
  }

  void _onBook(Room room) {
    context.pushNamed('bookingStep1', pathParameters: {'roomId': room.id});
  }

  void _onOpenBookings() {
    context.goNamed('bookings');
  }

  @override
  Widget build(BuildContext context) {
    final rooms = AppData.getRoomsSortedByPrice(_priceAsc);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Доступные номера',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              IconButton(
                tooltip: _priceAsc ? 'Цена: по возрастанию' : 'Цена: по убыванию',
                onPressed: _toggleSort,
                icon: Icon(_priceAsc ? Icons.arrow_upward : Icons.arrow_downward),
              ),
              ElevatedButton.icon(
                onPressed: _onOpenBookings,
                icon: const Icon(Icons.list),
                label: const Text('Мои брони'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: rooms.length,
            itemBuilder: (context, index) {
              final r = rooms[index];
              return RoomCard(room: r, onBook: _onBook);
            },
          ),
        ),
      ],
    );
  }
}


