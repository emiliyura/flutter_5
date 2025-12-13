import '../entities/booking.dart';
import '../entities/room.dart';
import '../repositories/bookings_repository.dart';

/// Use Case: Создание бронирования
/// Инкапсулирует бизнес-логику создания бронирования
class CreateBookingUseCase {
  final BookingsRepository _repository;

  CreateBookingUseCase(this._repository);

  /// Выполнить use case
  /// 
  /// Валидирует данные и создает бронирование
  Future<Booking> call({
    required Room room,
    required String guestName,
    required DateTime checkIn,
    required DateTime checkOut,
  }) async {
    // Бизнес-правила валидации
    if (guestName.trim().isEmpty) {
      throw Exception('Имя гостя не может быть пустым');
    }

    if (guestName.trim().length < 2) {
      throw Exception('Имя гостя должно содержать минимум 2 символа');
    }

    if (!checkOut.isAfter(checkIn)) {
      throw Exception('Дата выезда должна быть позже даты заезда');
    }

    if (checkIn.isBefore(DateTime.now())) {
      throw Exception('Дата заезда не может быть в прошлом');
    }

    // Создание бронирования через репозиторий
    return await _repository.createBooking(
      room: room,
      guestName: guestName.trim(),
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }
}
