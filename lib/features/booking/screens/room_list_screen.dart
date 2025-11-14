import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../booking/models/room.dart';
import '../widgets/room_card.dart';
import '../providers/rooms_provider.dart';

class RoomListScreen extends ConsumerWidget {
  const RoomListScreen({super.key});
  void _onBook(BuildContext context, Room room) {
    context.go('/booking/step1/${room.id}');
  }
  void _onOpenBookings(BuildContext context) {
    context.push('/bookings');
  }
  void _toggleSort(WidgetRef ref) {
    ref.read(roomsProviderProvider.notifier).toggleSort();
  }
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsState = ref.watch(roomsProviderProvider);
    final roomsAsync = roomsState.rooms.whenData((roomList) {
      final sorted = List<Room>.from(roomList);
      sorted.sort((a, b) => roomsState.sortAscending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      return sorted;
    });
    final isRefreshing = roomsState.isRefreshing;
    final sortAscending = roomsState.sortAscending;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Номера'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: sortAscending ? 'Цена: по возрастанию' : 'Цена: по убыванию',
            onPressed: () => _toggleSort(ref),
            icon: Icon(sortAscending ? Icons.arrow_upward : Icons.arrow_downward),
          ),
          IconButton(
            tooltip: 'Мои бронирования',
            onPressed: () => _onOpenBookings(context),
            icon: const Icon(Icons.list),
          ),
        ],
      ),
      body: roomsAsync.when(
        data: (rooms) => RefreshIndicator(
          onRefresh: () async {
            await ref.read(roomsProviderProvider.notifier).refresh();
          },
          child: isRefreshing
              ? const Center(child: CircularProgressIndicator())
              : rooms.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.hotel_outlined,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Номера не найдены',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: rooms.length,
                      itemBuilder: (context, index) {
                        final r = rooms[index];
                        return RoomCard(room: r, onBook: (room) => _onBook(context, room));
                      },
                    ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки номеров',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.red[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  ref.invalidate(roomsProviderProvider);
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Повторить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


