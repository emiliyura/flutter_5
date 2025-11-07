import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../booking/models/room.dart';
import '../../booking/models/booking.dart';
import '../../booking/models/app_data.dart';
import '../widgets/room_card.dart';
import 'booking_list_screen.dart';

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
    context.go('/booking/step1/${room.id}');
  }

  void _onOpenBookings() {
    context.push('/bookings');
  }


  @override
  Widget build(BuildContext context) {
    final rooms = AppData.getRoomsSortedByPrice(_priceAsc);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Номера'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: _priceAsc ? 'Цена: по возрастанию' : 'Цена: по убыванию',
            onPressed: _toggleSort,
            icon: Icon(_priceAsc ? Icons.arrow_upward : Icons.arrow_downward),
          ),
          IconButton(
            tooltip: 'Мои бронирования',
            onPressed: _onOpenBookings,
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: rooms.length,
        itemBuilder: (context, index) {
          final r = rooms[index];
          return RoomCard(room: r, onBook: _onBook);
        },
      ),
    );
  }
}


