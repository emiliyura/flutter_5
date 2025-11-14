import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';
import 'booking_step_indicator.dart';
import '../providers/booking_dates_provider.dart';
import '../providers/rooms_provider.dart';

class BookingStep1Screen extends ConsumerStatefulWidget {
  final Room room;

  const BookingStep1Screen({
    super.key,
    required this.room,
  });

  @override
  ConsumerState<BookingStep1Screen> createState() => _BookingStep1ScreenState();
}

class _BookingStep1ScreenState extends ConsumerState<BookingStep1Screen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(roomsProviderProvider.notifier).setSelectedRoom(widget.room);
      }
    });
  }

  Future<void> _pickDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final datesState = ref.read(bookingDatesProviderProvider);
    final currentCheckIn = datesState.checkIn;
    final currentCheckOut = datesState.checkOut;
    final initial = isCheckIn
        ? (currentCheckIn ?? now)
        : (currentCheckOut ?? now.add(const Duration(days: 1)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;

    if (isCheckIn) {
      ref.read(bookingDatesProviderProvider.notifier).setCheckIn(picked);
      final checkOut = datesState.checkOut;
      if (checkOut == null || !checkOut.isAfter(picked)) {
        ref.read(bookingDatesProviderProvider.notifier).setCheckOut(picked.add(const Duration(days: 1)));
      }
    } else {
      ref.read(bookingDatesProviderProvider.notifier).setCheckOut(picked);
      final checkIn = datesState.checkIn;
      if (checkIn == null || !picked.isAfter(checkIn)) {
        ref.read(bookingDatesProviderProvider.notifier).setCheckIn(picked.subtract(const Duration(days: 1)));
      }
    }
  }

  void _handleNext() {
    final datesState = ref.read(bookingDatesProviderProvider);
    final validationError = datesState.validationError;
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationError)),
      );
      return;
    }

    final checkIn = datesState.checkIn;
    final checkOut = datesState.checkOut;

    if (checkIn == null || checkOut == null) return;

    final path = '/booking/step2/${widget.room.id}';
    final checkInStr = Uri.encodeComponent(checkIn.toIso8601String());
    final checkOutStr = Uri.encodeComponent(checkOut.toIso8601String());
    context.go('$path?checkIn=$checkInStr&checkOut=$checkOutStr');
  }

  @override
  Widget build(BuildContext context) {
    final datesState = ref.watch(bookingDatesProviderProvider);
    final checkIn = datesState.checkIn;
    final checkOut = datesState.checkOut;
    final nights = datesState.nightsCount;
    final totalPrice = datesState.getTotalPrice(widget.room.price);
    final validationError = datesState.validationError;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Бронирование - Шаг 1'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Номер: ${widget.room.title}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              const BookingStepIndicator(currentStep: 1),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Шаг 1: Выбор дат',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickDate(context, true),
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Дата заезда'),
                                child: Text(checkIn == null ? 'Выберите дату' : DateHelpers.formatDate(checkIn)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickDate(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Дата выезда'),
                                child: Text(checkOut == null ? 'Выберите дату' : DateHelpers.formatDate(checkOut)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (nights > 0) ...[
                        const SizedBox(height: 24),
                        Card(
                          color: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.3),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Количество ночей:',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      '$nights',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Цена за ночь:',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                    Text(
                                      '${widget.room.price.toStringAsFixed(2)} ₽',
                                      style: Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ],
                                ),
                                const Divider(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Итого:',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} ₽',
                                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).colorScheme.primary,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (validationError != null) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 20),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  validationError,
                                  style: TextStyle(color: Colors.red[700], fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton.icon(
                            onPressed: validationError == null ? _handleNext : null,
                            icon: const Icon(Icons.arrow_forward),
                            label: const Text('Далее'),
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

