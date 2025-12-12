import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'loyalty_provider.g.dart';

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

  LoyaltyOperation({
    required this.id,
    required this.type,
    required this.points,
    required this.date,
    required this.description,
    this.bookingId,
  });
}

class LoyaltyState {
  final int currentPoints;
  final List<LoyaltyOperation> operations;

  LoyaltyState({
    this.currentPoints = 0,
    this.operations = const [],
  });

  LoyaltyState copyWith({
    int? currentPoints,
    List<LoyaltyOperation>? operations,
  }) {
    return LoyaltyState(
      currentPoints: currentPoints ?? this.currentPoints,
      operations: operations ?? this.operations,
    );
  }
}

@riverpod
class LoyaltyProvider extends _$LoyaltyProvider {
  @override
  LoyaltyState build() {
    return LoyaltyState(
      currentPoints: 0,
      operations: [],
    );
  }

  void earnPoints(int points, String description, {String? bookingId}) {
    if (points <= 0) return;

    final operation = LoyaltyOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LoyaltyOperationType.earned,
      points: points,
      date: DateTime.now(),
      description: description,
      bookingId: bookingId,
    );

    state = state.copyWith(
      currentPoints: state.currentPoints + points,
      operations: [operation, ...state.operations],
    );
  }

  void spendPoints(int points, String description) {
    if (points <= 0 || points > state.currentPoints) return;

    final operation = LoyaltyOperation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: LoyaltyOperationType.spent,
      points: points,
      date: DateTime.now(),
      description: description,
    );

    state = state.copyWith(
      currentPoints: state.currentPoints - points,
      operations: [operation, ...state.operations],
    );
  }

  List<LoyaltyOperation> getOperationsByType(LoyaltyOperationType? type) {
    if (type == null) return state.operations;
    return state.operations.where((op) => op.type == type).toList();
  }

  List<LoyaltyOperation> getRecentOperations({int limit = 10}) {
    final sorted = List<LoyaltyOperation>.from(state.operations);
    sorted.sort((a, b) => b.date.compareTo(a.date));
    return sorted.take(limit).toList();
  }
}



