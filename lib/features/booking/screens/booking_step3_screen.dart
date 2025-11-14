import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';
import 'booking_step_indicator.dart';
import '../providers/booking_state_provider.dart';
import '../providers/booking_dates_provider.dart';

class BookingStep3Screen extends ConsumerStatefulWidget {
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

  @override
  ConsumerState<BookingStep3Screen> createState() => _BookingStep3ScreenState();
}

class _BookingStep3ScreenState extends ConsumerState<BookingStep3Screen> {
  bool _datesSet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_datesSet) {
        ref.read(bookingDatesProviderProvider.notifier).setCheckIn(widget.checkIn);
        ref.read(bookingDatesProviderProvider.notifier).setCheckOut(widget.checkOut);
        _datesSet = true;
      }
    });
  }

  void _goToStep2() {
    final path = '/booking/step2/${widget.room.id}';
    final checkInStr = Uri.encodeComponent(widget.checkIn.toIso8601String());
    final checkOutStr = Uri.encodeComponent(widget.checkOut.toIso8601String());
    final guestNameStr = Uri.encodeComponent(widget.guestName);
    context.go('$path?checkIn=$checkInStr&checkOut=$checkOutStr&guestName=$guestNameStr');
  }

  Future<void> _saveBooking() async {
    await ref.read(bookingStateProviderProvider.notifier).createBooking(
          room: widget.room,
          guestName: widget.guestName,
          checkIn: widget.checkIn,
          checkOut: widget.checkOut,
        );

    final bookingState = ref.read(bookingStateProviderProvider);
    if (bookingState.process.state == BookingProcessState.success) {
      await ref.read(bookingStateProviderProvider.notifier).refreshBookingsCache();
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      if (mounted) {
        context.go('/bookings');
      }
    } else if (bookingState.process.state == BookingProcessState.error) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProviderProvider);
    final bookingProcess = bookingState.process;
    final nights = widget.checkOut.difference(widget.checkIn).inDays;
    final totalPrice = widget.room.price * nights;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: bookingProcess.state == BookingProcessState.loading
              ? null
              : () => _goToStep2(),
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
              Text('Номер: ${widget.room.title}', style: Theme.of(context).textTheme.titleLarge),
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
                              Text('Номер: ${widget.room.title}', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text('Гость: ${widget.guestName}'),
                              const SizedBox(height: 8),
                              Text('Заезд: ${DateHelpers.formatDate(widget.checkIn)}'),
                              const SizedBox(height: 8),
                              Text('Выезд: ${DateHelpers.formatDate(widget.checkOut)}'),
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
                      if (bookingProcess.state == BookingProcessState.loading) ...[
                        const SizedBox(height: 20),
                        Card(
                          color: Colors.blue.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Обработка бронирования...',
                                    style: TextStyle(
                                      color: Colors.blue[900],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (bookingProcess.state == BookingProcessState.error) ...[
                        const SizedBox(height: 20),
                        Card(
                          color: Colors.red.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.error_outline, color: Colors.red[700]),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Ошибка при создании бронирования',
                                        style: TextStyle(
                                          color: Colors.red[700],
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                if (bookingProcess.errorMessage != null) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    bookingProcess.errorMessage!,
                                    style: TextStyle(color: Colors.red[700], fontSize: 12),
                                  ),
                                ],
                                const SizedBox(height: 12),
                                ElevatedButton.icon(
                                  onPressed: () {
                                    ref.read(bookingStateProviderProvider.notifier).resetProcess();
                                    _saveBooking();
                                  },
                                  icon: const Icon(Icons.refresh),
                                  label: const Text('Повторить'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (bookingProcess.state == BookingProcessState.success) ...[
                        const SizedBox(height: 20),
                        Card(
                          color: Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle, color: Colors.green[700]),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Text(
                                    'Бронирование успешно создано!',
                                    style: TextStyle(
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: bookingProcess.state == BookingProcessState.loading
                                ? null
                                : () => _goToStep2(),
                            child: const Text('Отмена'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: bookingProcess.state == BookingProcessState.loading
                                ? null
                                : () => _saveBooking(),
                            icon: bookingProcess.state == BookingProcessState.loading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.check),
                            label: Text(
                              bookingProcess.state == BookingProcessState.loading
                                  ? 'Обработка...'
                                  : 'Подтвердить бронирование',
                            ),
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

