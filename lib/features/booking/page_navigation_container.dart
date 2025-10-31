import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/room_list_screen.dart';
import 'screens/booking_form_screen.dart';
import 'screens/booking_list_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';
import 'models/room.dart';
import 'models/booking.dart';
import 'models/booking_repository.dart';

class PageNavigationContainer extends StatefulWidget {
  final int initialIndex;
  const PageNavigationContainer({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<PageNavigationContainer> createState() => _PageNavigationContainerState();
}

class _PageNavigationContainerState extends State<PageNavigationContainer> {
  int _currentPageIndex = 0;
  bool _priceAsc = true;

  // Репозиторий для сохранения состояния между заменами маршрутов
  final BookingRepository _repo = BookingRepository.instance;
  Room? _selectedRoomForBooking;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.initialIndex;
  }

  void _navigateToPage(int index) {
    if (index == _currentPageIndex) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => PageNavigationContainer(initialIndex: index),
      ),
    );
  }

  void _showBookingForm(Room room) {
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
      _repo.addBooking(newBooking);
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const PageNavigationContainer(initialIndex: 2),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Бронирование создано')),
    );
  }

  void _cancelBooking(String bookingId) {
    setState(() {
      _repo.cancelBooking(bookingId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Бронирование отменено')),
    );
  }

  Widget _buildBody() {
    switch (_currentPageIndex) {
      case 0:
        return HomeScreen(
          onShowRooms: () => _navigateToPage(1),
          onShowBookings: () => _navigateToPage(2),
          onShowProfile: () => _navigateToPage(3),
          onShowSettings: () => _navigateToPage(4),
        );
      case 1:
        return RoomListScreen(
          rooms: _repo.roomsSortedByPrice(_priceAsc),
          onBook: _showBookingForm,
          onOpenBookings: () => _navigateToPage(2),
          priceAsc: _priceAsc,
          onToggleSort: () => setState(() => _priceAsc = !_priceAsc),
        );
      case 2:
        return BookingListScreen(
          bookings: _repo.bookings,
          rooms: _repo.rooms,
          onCancelBooking: _cancelBooking,
        );
      case 3:
        return ProfileScreen(
          onBack: () => _navigateToPage(0),
        );
      case 4:
        return SettingsScreen(
          onBack: () => _navigateToPage(0),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
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
    super.dispose();
  }
}