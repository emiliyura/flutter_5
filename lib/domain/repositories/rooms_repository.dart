import '../entities/room.dart';

/// Абстрактный интерфейс репозитория для работы с номерами
/// Определяется в Domain Layer, реализуется в Data Layer
abstract class RoomsRepository {
  /// Получить все номера
  Future<List<Room>> getRooms();

  /// Получить номер по ID
  Future<Room?> getRoomById(String roomId);

  /// Поиск номеров по запросу
  Future<List<Room>> searchRooms(String query);

  /// Обновить список номеров
  Future<void> refreshRooms();
}
