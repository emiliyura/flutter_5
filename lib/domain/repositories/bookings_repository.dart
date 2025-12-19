import '../entities/booking.dart';
import '../entities/room.dart';


abstract class BookingsRepository {
  Future<List<Booking>> getBookings();

  Future<Booking?> getBookingById(String bookingId);

  Future<Booking> createBooking({
    required Room room,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
  });

  Future<void> cancelBooking(String bookingId);

  Future<void> refreshBookings();
}










