import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';
import 'booking_step_indicator.dart';

class BookingStep1Screen extends StatefulWidget {
  final Room room;
  final void Function(String guestName, DateTime checkIn, DateTime checkOut) onNext;
  final VoidCallback onCancel;

  const BookingStep1Screen({
    super.key,
    required this.room,
    required this.onNext,
    required this.onCancel,
  });

  @override
  State<BookingStep1Screen> createState() => _BookingStep1ScreenState();
}

class _BookingStep1ScreenState extends State<BookingStep1Screen> {
  DateTime? _checkIn;
  DateTime? _checkOut;

  Future<void> _pickDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final initial = isCheckIn ? (_checkIn ?? now) : (_checkOut ?? now.add(const Duration(days: 1)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );

    if (picked == null) return;

    setState(() {
      if (isCheckIn) {
        _checkIn = picked;
        if (_checkOut == null || !_checkOut!.isAfter(_checkIn!)) {
          _checkOut = _checkIn!.add(const Duration(days: 1));
        }
      } else {
        _checkOut = picked;
        if (_checkIn == null || !_checkOut!.isAfter(_checkIn!)) {
          _checkIn = _checkOut!.subtract(const Duration(days: 1));
        }
      }
    });
  }

  void _handleNext() {
    if (_checkIn == null || _checkOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Выберите даты')),
      );
      return;
    }
    if (!_checkOut!.isAfter(_checkIn!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Дата выезда должна быть позже даты заезда')),
      );
      return;
    }
    widget.onNext('', _checkIn!, _checkOut!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
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
                                child: Text(_checkIn == null ? 'Выберите дату' : DateHelpers.formatDate(_checkIn!)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: InkWell(
                              onTap: () => _pickDate(context, false),
                              child: InputDecorator(
                                decoration: const InputDecoration(labelText: 'Дата выезда'),
                                child: Text(_checkOut == null ? 'Выберите дату' : DateHelpers.formatDate(_checkOut!)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: widget.onCancel,
                            child: const Text('Отмена'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed: _handleNext,
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

