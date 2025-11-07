import 'package:flutter/material.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';
import 'booking_step_indicator.dart';
import 'booking_step1_screen.dart';
import 'booking_step3_screen.dart';

class BookingStep2Screen extends StatefulWidget {
  final Room room;
  final String? initialGuestName;
  final DateTime initialCheckIn;
  final DateTime initialCheckOut;

  const BookingStep2Screen({
    super.key,
    required this.room,
    this.initialGuestName,
    required this.initialCheckIn,
    required this.initialCheckOut,
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

  void _goToStep1() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingStep1Screen(room: widget.room),
      ),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  void _handleNext() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BookingStep3Screen(
          room: widget.room,
          guestName: _nameCtrl.text.trim(),
          checkIn: widget.initialCheckIn,
          checkOut: widget.initialCheckOut,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: _goToStep1,
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
                            onPressed: _goToStep1,
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

