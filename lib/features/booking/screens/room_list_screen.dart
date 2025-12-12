import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../booking/models/room.dart';
import '../widgets/room_card.dart';
import '../providers/rooms_provider.dart';

class RoomListScreen extends ConsumerStatefulWidget {
  const RoomListScreen({super.key});

  @override
  ConsumerState<RoomListScreen> createState() => _RoomListScreenState();
}

class _RoomListScreenState extends ConsumerState<RoomListScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {}); // Обновляем состояние для кнопки очистки
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onBook(BuildContext context, Room room) {
    context.go('/booking/step1/${room.id}');
  }

  void _onOpenBookings(BuildContext context) {
    context.push('/bookings');
  }

  void _toggleSort(WidgetRef ref) {
    ref.read(roomsProviderProvider.notifier).toggleSort();
  }

  void _onSearchChanged(String query) {
    ref.read(roomsProviderProvider.notifier).setSearchQuery(query);
  }

  @override
  Widget build(BuildContext context) {
    final roomsState = ref.watch(roomsProviderProvider);
    final roomsProvider = ref.read(roomsProviderProvider.notifier);
    final roomsAsync = roomsProvider.getFilteredRooms();
    final isRefreshing = roomsState.isRefreshing;
    final sortAscending = roomsState.sortAscending;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Номера'),
        automaticallyImplyLeading: false,
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
      body: Column(
        children: [
          // Поле поиска
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Поиск номеров...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surface,
              ),
              onChanged: _onSearchChanged,
            ),
          ),
          // Список номеров
          Expanded(
            child: roomsAsync.when(
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
          ),
        ],
      ),
    );
  }
}
