import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/room_list_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/booking_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'models/room.dart';
import 'models/booking.dart';

class PageNavigationContainer extends StatefulWidget {
  const PageNavigationContainer({Key? key}) : super(key: key);

  @override
  State<PageNavigationContainer> createState() => _PageNavigationContainerState();
}

class _PageNavigationContainerState extends State<PageNavigationContainer> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  // Данные приложения
  final List<Room> _rooms = [
    Room(id: 'r1', title: 'Стандартный однокомнатный', price: 50.0, beds: 1, amenities: ['Wi-Fi', 'Телевизор']),
    Room(id: 'r2', title: 'Двухместный улучшенный', price: 80.0, beds: 2, amenities: ['Wi-Fi', 'Кондиционер']),
    Room(id: 'r3', title: 'Люкс', price: 150.0, beds: 2, amenities: ['Wi-Fi', 'Кондиционер', 'Мини-бар']),
    Room(id: 'r4', title: 'Семейный номер', price: 120.0, beds: 3, amenities: ['Wi-Fi', 'Кондиционер', 'Балкон', 'Детская кроватка']),
    Room(id: 'r5', title: 'Президентский люкс', price: 300.0, beds: 2, amenities: ['Wi-Fi', 'Кондиционер', 'Мини-бар', 'Джакузи', 'Панорамные окна', 'Персональный консьерж']),
  ];

  List<Booking> _bookings = [];
  Room? _selectedRoomForBooking;

  void _navigateToPage(int index) {
    setState(() {
      _currentPageIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showBookingForm(Room room) {
    // Открыть экран формы бронирования как отдельный маршрут
    _selectedRoomForBooking = room;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingFormScreen(
          room: room,
          onSave: _createBooking,
          onCancel: () => Navigator.pop(context),
        ),
        fullscreenDialog: false,
      ),
    );
  }

  void _createBooking(String guestName, DateTime checkIn, DateTime checkOut) {
    Navigator.pop(context); // Закрыть форму
    final room = _selectedRoomForBooking;
    if (room == null) return;

    final newBooking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: room.id,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
    );

    setState(() {
      _bookings = [..._bookings, newBooking];
      final roomIndex = _rooms.indexWhere((r) => r.id == room.id);
      if (roomIndex != -1) {
        _rooms[roomIndex] = _rooms[roomIndex].copyWith(isBooked: true);
      }
      _currentPageIndex = 2; // перейти на вкладку Брони
    });

    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Бронирование создано')),
    );
  }

  void _cancelBooking(String bookingId) {
    setState(() {
      final idx = _bookings.indexWhere((b) => b.id == bookingId);
      if (idx != -1) {
        final roomId = _bookings[idx].roomId;
        _bookings.removeAt(idx);
        final roomIndex = _rooms.indexWhere((r) => r.id == roomId);
        if (roomIndex != -1) {
          // Освободить номер, если больше нет активных бронирований для него
          final stillBooked = _bookings.any((b) => b.roomId == roomId);
          _rooms[roomIndex] = _rooms[roomIndex].copyWith(isBooked: stillBooked);
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Бронирование отменено')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        children: [
          // 1. Главная
          HomeScreen(
            onShowRooms: () => _navigateToPage(1),
            onShowBookings: () => _navigateToPage(2),
            onShowProfile: () => _navigateToPage(3),
            onShowSettings: () => _navigateToPage(4),
          ),

          // 2. Список номеров
          RoomListScreen(
            rooms: _rooms,
            onBook: _showBookingForm,
            onOpenBookings: () => _navigateToPage(2),
          ),

          // 3. Бронирования
          BookingListScreen(
            bookings: _bookings,
            rooms: _rooms,
            onCancelBooking: _cancelBooking,
          ),

          // 4. Профиль
          ProfileScreen(
            onBack: () => _navigateToPage(0),
          ),

          // 5. Настройки
          SettingsScreen(
            onBack: () => _navigateToPage(0),
          ),
        ],
      ),

      // Bottom Navigation Bar для вертикальной навигации
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPageIndex,
        onTap: _navigateToPage,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Главная'),
          BottomNavigationBarItem(icon: Icon(Icons.hotel), label: 'Номера'),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'Брони'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Настройки'),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}