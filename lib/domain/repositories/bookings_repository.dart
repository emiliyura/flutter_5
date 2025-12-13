import '../entities/booking.dart';
import '../entities/room.dart';

/// Абстрактный интерфейс репозитория для работы с бронированиями
/// Определяется в Domain Layer, реализуется в Data Layer
abstract class BookingsRepository {
  /// Получить все бронирования
  Future<List<Booking>> getBookings();

  /// Получить бронирование по ID
  Future<Booking?> getBookingById(String bookingId);

  /// Создать новое бронирование
  Future<Booking> createBooking({
    required Room room,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
  });

  /// Удалить бронирование
  Future<void> cancelBooking(String bookingId);

  /// Обновить список бронирований
  Future<void> refreshBookings();
}
