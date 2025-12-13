import '../models/room_dto.dart';
import 'rooms_local_data_source.dart';

/// Реализация локального источника данных для номеров
/// Временная реализация с хранением в памяти (для демонстрации)
class RoomsLocalDataSourceImpl implements RoomsLocalDataSource {
  List<RoomDto> _cachedRooms = [];

  @override
  Future<List<RoomDto>> getRooms() async {
    // Имитация задержки работы с локальной БД
    await Future.delayed(const Duration(milliseconds: 100));
    return List.from(_cachedRooms);
  }

  @override
  Future<void> saveRooms(List<RoomDto> rooms) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _cachedRooms = List.from(rooms);
  }

  @override
  Future<void> clearRooms() async {
    await Future.delayed(const Duration(milliseconds: 50));
    _cachedRooms.clear();
  }
}
