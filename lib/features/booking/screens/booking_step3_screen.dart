import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';
import 'booking_step_indicator.dart';

class BookingStep3Screen extends StatelessWidget {
  final Room room;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;
  final void Function(String guestName, DateTime checkIn, DateTime checkOut) onSave;
  final VoidCallback onCancel;

  const BookingStep3Screen({
    super.key,
    required this.room,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final nights = checkOut.difference(checkIn).inDays;
    final totalPrice = room.price * nights;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
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
                            onPressed: onCancel,
                            child: const Text('Отмена'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: () => onSave(guestName, checkIn, checkOut),
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

