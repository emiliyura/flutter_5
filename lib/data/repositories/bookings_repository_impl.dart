import 'package:drift/drift.dart';
import '../../domain/entities/booking.dart' as domain;
import '../../domain/entities/room.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../database/app_database.dart';

/// Реализация репозитория для работы с бронированиями с использованием Drift
class BookingsRepositoryImpl implements BookingsRepository {
  final AppDatabase _db;

  BookingsRepositoryImpl(this._db);

  @override
  Future<List<domain.Booking>> getBookings() async {
    final dbBookings = await _db.getAllBookings();
    return dbBookings.map((b) => domain.Booking(
      id: b.id.toString(),
      roomId: b.roomId,
      guestName: b.guestName,
      checkIn: b.checkInDate,
      checkOut: b.checkOutDate,
    )).toList();
  }

  @override
  Future<domain.Booking?> getBookingById(String bookingId) async {
    final dbBooking = await _db.getBookingByStringId(bookingId);
    if (dbBooking == null) return null;
    return domain.Booking(
      id: dbBooking.id.toString(),
      roomId: dbBooking.roomId,
      guestName: dbBooking.guestName,
      checkIn: dbBooking.checkInDate,
      checkOut: dbBooking.checkOutDate,
    );
  }

  @override
  Future<domain.Booking> createBooking({
    required Room room,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    // Проверка на ошибку (для тестирования)
    if (guestName.toLowerCase().contains('error')) {
      throw Exception('Ошибка при создании бронирования');
    }

    final nights = checkOut.difference(checkIn).inDays;
    final totalPrice = room.price * nights;

    final companion = BookingsCompanion.insert(
      roomId: room.id,
      roomTitle: room.title,
      guestName: guestName,
      checkInDate: checkIn,
      checkOutDate: checkOut,
      totalPrice: totalPrice,
      status: 'confirmed',
    );

    final id = await _db.createBooking(companion);

    return domain.Booking(
      id: id.toString(),
      roomId: room.id,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _db.deleteBooking(bookingId);
  }

  @override
  Future<void> refreshBookings() async {
    // В реальном приложении здесь будет синхронизация с сервером
  }
}
