import '../repositories/loyalty_repository.dart';

/// Use Case: Начисление баллов лояльности
/// Инкапсулирует бизнес-логику начисления баллов
class EarnLoyaltyPointsUseCase {
  final LoyaltyRepository _repository;

  EarnLoyaltyPointsUseCase(this._repository);

  /// Выполнить use case
  /// 
  /// Начисляет баллы за бронирование (1% от стоимости)
  Future<void> call({
    required double totalPrice,
    required String roomTitle,
    required String bookingId,
  }) async {
    // Бизнес-правило: 1 балл = 1% от стоимости
    final points = (totalPrice * 0.01).round();

    if (points > 0) {
      await _repository.earnPoints(
        points: points,
        description: 'Бронирование номера "$roomTitle"',
        bookingId: bookingId,
      );
    }
  }
}










