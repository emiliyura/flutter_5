import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';
import 'booking_step_indicator.dart';

class BookingStep2Screen extends StatefulWidget {
  final Room room;
  final String? initialGuestName;
  final DateTime? initialCheckIn;
  final DateTime? initialCheckOut;
  final void Function(String guestName, DateTime checkIn, DateTime checkOut) onNext;
  final VoidCallback onCancel;

  const BookingStep2Screen({
    super.key,
    required this.room,
    this.initialGuestName,
    this.initialCheckIn,
    this.initialCheckOut,
    required this.onNext,
    required this.onCancel,
  });

  @override
  State<BookingStep2Screen> createState() => _BookingStep2ScreenState();
}

class _BookingStep2ScreenState extends State<BookingStep2Screen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialGuestName ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;
    if (widget.initialCheckIn == null || widget.initialCheckOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ошибка: даты не выбраны')),
      );
      return;
    }
    widget.onNext(_nameCtrl.text.trim(), widget.initialCheckIn!, widget.initialCheckOut!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Бронирование - Шаг 2'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Номер: ${widget.room.title}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 24),
              const BookingStepIndicator(currentStep: 2),
              const SizedBox(height: 32),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Шаг 2: Данные гостя',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 24),
                      Form(
                        key: _formKey,
                        child: TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(labelText: 'Имя гостя'),
                          validator: (v) {
                            if (StringHelpers.isNullOrEmpty(v)) return 'Введите имя';
                            if (!ValidationHelpers.hasMinLength(v!, 2)) {
                              return 'Имя должно содержать минимум 2 символа';
                            }
                            return null;
                          },
                        ),
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

