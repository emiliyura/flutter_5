import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../booking/models/room.dart';
import '../widgets/booking_item.dart';
import '../providers/booking_state_provider.dart';
import '../providers/rooms_provider.dart';

class BookingListScreen extends ConsumerWidget {
  const BookingListScreen({super.key});

  void _cancelBooking(WidgetRef ref, String bookingId) {
    ref.read(bookingStateProviderProvider.notifier).removeBooking(bookingId);
    ref.read(bookingStateProviderProvider.notifier).refreshBookingsCache();
  }

  void _navigateToRooms(BuildContext context) {
    context.push('/rooms');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingStateProviderProvider);
    final bookingsCache = bookingState.getBookingsCache();
    final roomsState = ref.watch(roomsProviderProvider);
    final roomsAsync = roomsState.rooms;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои бронирования'),
        leading: IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            tooltip: 'Обновить',
            onPressed: () {
              ref.read(bookingStateProviderProvider.notifier).refreshBookingsCache();
            },
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            tooltip: 'Номера',
            onPressed: () => _navigateToRooms(context),
            icon: const Icon(Icons.hotel),
          ),
        ],
      ),
      body: bookingsCache.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return _buildEmptyState();
          }

          return roomsAsync.when(
            data: (rooms) => RefreshIndicator(
              onRefresh: () async {
                await ref.read(bookingStateProviderProvider.notifier).refreshBookingsCache();
              },
              child: ListView.builder(
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
                    onCancel: () => _cancelBooking(ref, b.id),
                  );
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
                    style: TextStyle(color: Colors.red[700]),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Ошибка загрузки бронирований',
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
                  ref.read(bookingStateProviderProvider.notifier).refreshBookingsCache();
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

  Widget _buildEmptyState() {
    return Stack(
      children: [
        Positioned.fill(
          child: CachedNetworkImage(
            imageUrl: '', //'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRmCa_Cmte1PJ3rwqu425kd3fyVAdmFqSBA7L6B0cjvVcAQr1AapPwU100OZT5tsiVrjts&usqp=CAU',
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
                  color: Colors.white,
                  size: 0,
                ),
              ),
            ),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
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


