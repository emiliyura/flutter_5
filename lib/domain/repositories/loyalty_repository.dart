import '../entities/loyalty_operation.dart';

/// Абстрактный интерфейс репозитория для работы с программой лояльности
/// Определяется в Domain Layer, реализуется в Data Layer
abstract class LoyaltyRepository {
  /// Получить текущий баланс баллов
  Future<int> getCurrentPoints();

  /// Получить историю операций
  Future<List<LoyaltyOperation>> getOperations();

  /// Начислить баллы
  Future<void> earnPoints({
    required int points,
    required String description,
    String? bookingId,
  });

  /// Потратить баллы
  Future<void> spendPoints({
    required int points,
    required String description,
  });
}
