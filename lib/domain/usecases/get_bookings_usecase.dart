import '../entities/booking.dart';
import '../repositories/bookings_repository.dart';

/// Use Case: Получение списка бронирований
/// Инкапсулирует бизнес-логику получения бронирований
class GetBookingsUseCase {
  final BookingsRepository _repository;

  GetBookingsUseCase(this._repository);

  /// Выполнить use case
  Future<List<Booking>> call() async {
    return await _repository.getBookings();
  }
}
