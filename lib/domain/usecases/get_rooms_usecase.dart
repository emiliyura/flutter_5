import '../entities/room.dart';
import '../repositories/rooms_repository.dart';

/// Use Case: Получение списка номеров
/// Инкапсулирует бизнес-логику получения номеров
class GetRoomsUseCase {
  final RoomsRepository _repository;

  GetRoomsUseCase(this._repository);

  /// Выполнить use case
  Future<List<Room>> call() async {
    return await _repository.getRooms();
  }
}
