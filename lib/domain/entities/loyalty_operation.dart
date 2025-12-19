/// Domain Entity - LoyaltyOperation
/// Чистая бизнес-модель без зависимостей от Flutter или внешних библиотек
enum LoyaltyOperationType {
  earned, // Начисление
  spent,  // Трата
}

class LoyaltyOperation {
  final String id;
  final LoyaltyOperationType type;
  final int points;
  final DateTime date;
  final String description;
  final String? bookingId;

  const LoyaltyOperation({
    required this.id,
    required this.type,
    required this.points,
    required this.date,
    required this.description,
    this.bookingId,
  });
}










