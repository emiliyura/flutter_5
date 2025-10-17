import 'package:flutter/material.dart';
import 'models/room.dart';
import 'models/booking.dart';
import 'screens/room_list_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/booking_list_screen.dart';

enum Screen { list, form, bookings }

class BookingContainer extends StatefulWidget {
  const BookingContainer({Key? key}) : super(key: key);

  @override
  State<BookingContainer> createState() => _BookingContainerState();
}

class _BookingContainerState extends State<BookingContainer> {
  List<Room> _rooms = const [
    Room(id: 'r1', title: 'Стандартный однокомнатный', price: 50.0, beds: 1, amenities: ['Wi-Fi', 'Телевизор']),
    Room(id: 'r2', title: 'Двухместный улучшенный', price: 80.0, beds: 2, amenities: ['Wi-Fi', 'Кондиционер']),
    Room(id: 'r3', title: 'Люкс', price: 150.0, beds: 2, amenities: ['Wi-Fi', 'Кондиционер', 'Мини-бар']),
  ];

  List<Booking> _bookings = [];

  Screen _currentScreen = Screen.list;
  Room? _selectedRoom;

  String _generateId(String prefix) => '${prefix}_${DateTime.now().microsecondsSinceEpoch}';

  void _showList() {
    setState(() {
      _currentScreen = Screen.list;
      _selectedRoom = null;
    });
  }

  void _showForm(Room room) {
    setState(() {
      _currentScreen = Screen.form;
      _selectedRoom = room;
    });
  }

  void _showBookings() {
    setState(() {
      _currentScreen = Screen.bookings;
      _selectedRoom = null;
    });
  }

  void _createBooking({required String guestName, required DateTime checkIn, required DateTime checkOut}) {
    if (_selectedRoom == null) return;
    final booking = Booking(
      id: _generateId('b'),
      roomId: _selectedRoom!.id,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
    );

    setState(() {
      _bookings.add(booking);
      _rooms = _rooms.map((r) => r.id == _selectedRoom!.id ? r.copyWith(isBooked: true) : r).toList();
      _currentScreen = Screen.list;
      _selectedRoom = null;
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Бронирование успешно создано'),
      duration: Duration(seconds: 2),
    ));
  }

  void _cancelBooking(String bookingId) {
    final idx = _bookings.indexWhere((b) => b.id == bookingId);
    if (idx == -1) return;

    final removed = _bookings.removeAt(idx);
    setState(() {
      _rooms = _rooms.map((r) => r.id == removed.roomId ? r.copyWith(isBooked: false) : r).toList();
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Бронирование отменено'),
      duration: Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_currentScreen) {
      case Screen.list:
        body = RoomListScreen(
          rooms: _rooms,
          onBook: (room) => _showForm(room),
          onOpenBookings: _showBookings,
        );
        break;
      case Screen.form:
        body = BookingFormScreen(
          room: _selectedRoom!,
          onSave: (guestName, checkIn, checkOut) => _createBooking(guestName: guestName, checkIn: checkIn, checkOut: checkOut),
          onCancel: _showList,
        );
        break;
      case Screen.bookings:
        body = BookingListScreen(
          bookings: _bookings,
          rooms: _rooms,
          onCancelBooking: _cancelBooking,
          onBack: _showList,
        );
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hotel Booking Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt),
            tooltip: 'Мои бронирования',
            onPressed: _showBookings,
          )
        ],
      ),
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 300), child: body),
    );
  }
}


