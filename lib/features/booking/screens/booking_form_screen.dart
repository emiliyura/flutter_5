import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:local_utils/local_utils.dart';
import '../../booking/models/room.dart';

class BookingFormScreen extends StatefulWidget {
  final Room room;
  final void Function(String guestName, DateTime checkIn, DateTime checkOut) onSave;
  final VoidCallback onCancel;

  const BookingFormScreen({Key? key, required this.room, required this.onSave, required this.onCancel}) : super(key: key);

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  DateTime? _checkIn;
  DateTime? _checkOut;

  Future<void> _pickDate(BuildContext context, bool isCheckIn) async {
    final now = DateTime.now();
    final initial = isCheckIn ? ( _checkIn ?? now ) : ( _checkOut ?? now.add(const Duration(days:1)) );

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

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dateFmt = DateFormat('yyyy-MM-dd');

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back)),
        title: const Text('Бронирование'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Номер: ${widget.room.title}', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Expanded(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _nameCtrl,
                          decoration: const InputDecoration(labelText: 'Имя гостя'),
                          validator: (v) {
                            if (StringHelpers.isNullOrEmpty(v)) return 'Введите имя';
                            if (!ValidationHelpers.hasMinLength(v!, 2)) return 'Имя должно содержать минимум 2 символа';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
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
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) return;
                                if (_checkIn == null || _checkOut == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Выберите даты')));
                                  return;
                                }
                                if (!_checkOut!.isAfter(_checkIn!)) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Дата выезда должна быть позже даты заезда')));
                                  return;
                                }
                                widget.onSave(_nameCtrl.text.trim(), _checkIn!, _checkOut!);
                              },
                              icon: const Icon(Icons.check),
                              label: const Text('Подтвердить'),
                            ),
                            const SizedBox(width: 12),
                            TextButton(onPressed: widget.onCancel, child: const Text('Отмена'))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


