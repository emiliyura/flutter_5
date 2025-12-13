import '../models/room_dto.dart';

/// Локальный источник данных для номеров
/// В реальном приложении здесь будет работа с локальной БД (например, Hive, SQLite)
abstract class RoomsLocalDataSource {
  /// Получить номера из локального хранилища
  Future<List<RoomDto>> getRooms();

  /// Сохранить номера в локальное хранилище
  Future<void> saveRooms(List<RoomDto> rooms);

  /// Очистить локальное хранилище
  Future<void> clearRooms();
}
