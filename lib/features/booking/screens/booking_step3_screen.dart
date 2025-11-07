import 'package:flutter/material.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';
import '../../booking/models/booking.dart';
import '../../booking/models/app_data.dart';
import 'booking_step_indicator.dart';
import 'booking_step2_screen.dart';
import 'booking_list_screen.dart';

class BookingStep3Screen extends StatelessWidget {
  final Room room;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;

  const BookingStep3Screen({
    super.key,
    required this.room,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
  });

  void _goToStep2(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingStep2Screen(
          room: room,
          initialGuestName: guestName,
          initialCheckIn: checkIn,
          initialCheckOut: checkOut,
        ),
      ),
    );
  }

  void _saveBooking(BuildContext context) {
    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: room.id,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
    );
    AppData.addBooking(booking);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Мои бронирования')),
          body: const BookingListScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final nights = checkOut.difference(checkIn).inDays;
    final totalPrice = room.price * nights;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => _goToStep2(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Бронирование - Шаг 3'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Номер: ${room.title}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              const BookingStepIndicator(currentStep: 3),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Шаг 3: Подтверждение',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Номер: ${room.title}', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text('Гость: $guestName'),
                              const SizedBox(height: 8),
                              Text('Заезд: ${DateHelpers.formatDate(checkIn)}'),
                              const SizedBox(height: 8),
                              Text('Выезд: ${DateHelpers.formatDate(checkOut)}'),
                              const SizedBox(height: 8),
                              Text('Количество ночей: $nights'),
                              const Divider(),
                              Text(
                                'Итого: ${totalPrice.toStringAsFixed(2)} ₽',
                                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => _goToStep2(context),
                            child: const Text('Отмена'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => _saveBooking(context),
                            icon: const Icon(Icons.check),
                            label: const Text('Подтвердить бронирование'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

