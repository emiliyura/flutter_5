import '../../domain/entities/booking.dart';
import '../../domain/entities/room.dart';
import '../../domain/repositories/bookings_repository.dart';

/// Реализация репозитория для работы с бронированиями
/// Временная реализация с хранением в памяти (для демонстрации)
class BookingsRepositoryImpl implements BookingsRepository {
  final List<Booking> _bookings = [];

  @override
  Future<List<Booking>> getBookings() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_bookings);
  }

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _bookings.firstWhere((b) => b.id == bookingId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Booking> createBooking({
    required Room room,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    // Имитация задержки создания бронирования
    await Future.delayed(const Duration(seconds: 1));

    // Проверка на ошибку (для тестирования)
    if (guestName.toLowerCase().contains('error')) {
      throw Exception('Ошибка при создании бронирования');
    }

    final booking = Booking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      roomId: room.id,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
    );

    _bookings.add(booking);
    return booking;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _bookings.removeWhere((b) => b.id == bookingId);
  }

  @override
  Future<void> refreshBookings() async {
    // В реальном приложении здесь будет синхронизация с сервером
    await Future.delayed(const Duration(milliseconds: 300));
  }
}
