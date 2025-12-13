import '../models/room_dto.dart';

/// Удаленный источник данных для номеров
/// В реальном приложении здесь будет работа с API
abstract class RoomsRemoteDataSource {
  /// Получить номера с сервера
  Future<List<RoomDto>> getRooms();

  /// Получить номер по ID с сервера
  Future<RoomDto> getRoomById(String roomId);
}
