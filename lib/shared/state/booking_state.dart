import 'package:flutter/widgets.dart';
import '../../features/booking/models/booking.dart';

/// Состояние для управления бронированиями через InheritedWidget
class BookingState extends ChangeNotifier {
  final List<Booking> _bookings = [];

  List<Booking> get bookings => List.unmodifiable(_bookings);

  int get totalBookings => _bookings.length;

  void addBooking(Booking booking) {
    _bookings.add(booking);
    notifyListeners();
  }

  void cancelBooking(String bookingId) {
    _bookings.removeWhere((b) => b.id == bookingId);
    notifyListeners();
  }

  void clearAllBookings() {
    _bookings.clear();
    notifyListeners();
  }

  Booking? getBookingById(String id) {
    try {
      return _bookings.firstWhere((b) => b.id == id);
    } catch (e) {
      return null;
    }
  }
}

/// InheritedWidget провайдер для BookingState
class BookingStateProvider extends InheritedNotifier<BookingState> {
  const BookingStateProvider({
    super.key,
    required super.notifier,
    required super.child,
  });

  static BookingState of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<BookingStateProvider>();
    assert(provider != null, 'BookingStateProvider not found in widget tree');
    return provider!.notifier!;
  }
}

