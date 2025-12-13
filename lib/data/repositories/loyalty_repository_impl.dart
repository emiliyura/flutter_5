import '../../domain/entities/loyalty_operation.dart';
import '../../domain/repositories/loyalty_repository.dart';

/// Реализация репозитория для работы с программой лояльности
/// Временная реализация с хранением в памяти (для демонстрации)
class LoyaltyRepositoryImpl implements LoyaltyRepository {
  int _currentPoints = 0;
  final List<LoyaltyOperation> _operations = [];

  @override
  Future<int> getCurrentPoints() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _currentPoints;
  }

  @override
  Future<List<LoyaltyOperation>> getOperations() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.from(_operations);
  }

  @override
  Future<void> earnPoints({
    required int points,
    required String description,
    String? bookingId,
  }) async {
    if (points <= 0) return;

    await Future.delayed(const Duration(milliseconds: 100));

    final operation = LoyaltyOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LoyaltyOperationType.earned,
      points: points,
      date: DateTime.now(),
      description: description,
      bookingId: bookingId,
    );

    _currentPoints += points;
    _operations.insert(0, operation);
  }

  @override
  Future<void> spendPoints({
    required int points,
    required String description,
  }) async {
    if (points <= 0 || points > _currentPoints) return;

    await Future.delayed(const Duration(milliseconds: 100));

    final operation = LoyaltyOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LoyaltyOperationType.spent,
      points: points,
      date: DateTime.now(),
      description: description,
    );

    _currentPoints -= points;
    _operations.insert(0, operation);
  }
}
