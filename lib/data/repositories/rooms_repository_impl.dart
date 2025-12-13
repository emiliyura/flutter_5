import '../../domain/entities/room.dart';
import '../../domain/repositories/rooms_repository.dart';
import '../datasources/rooms_local_data_source.dart';
import '../datasources/rooms_remote_data_source.dart';

/// Реализация репозитория для работы с номерами
/// Использует паттерн Repository для абстракции источников данных
class RoomsRepositoryImpl implements RoomsRepository {
  final RoomsRemoteDataSource _remoteDataSource;
  final RoomsLocalDataSource _localDataSource;

  RoomsRepositoryImpl({
    required RoomsRemoteDataSource remoteDataSource,
    required RoomsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<List<Room>> getRooms() async {
    try {
      // Сначала пытаемся получить из кэша
      final cachedRooms = await _localDataSource.getRooms();
      if (cachedRooms.isNotEmpty) {
        return cachedRooms.map((dto) => dto.toEntity()).toList();
      }

      // Если кэш пуст, загружаем с сервера
      final remoteRooms = await _remoteDataSource.getRooms();
      
      // Сохраняем в кэш
      await _localDataSource.saveRooms(remoteRooms);
      
      return remoteRooms.map((dto) => dto.toEntity()).toList();
    } catch (e) {
      // В случае ошибки пытаемся вернуть данные из кэша
      final cachedRooms = await _localDataSource.getRooms();
      if (cachedRooms.isNotEmpty) {
        return cachedRooms.map((dto) => dto.toEntity()).toList();
      }
      rethrow;
    }
  }

  @override
  Future<Room?> getRoomById(String roomId) async {
    try {
      final roomDto = await _remoteDataSource.getRoomById(roomId);
      return roomDto.toEntity();
    } catch (e) {
      // Пытаемся найти в кэше
      final cachedRooms = await _localDataSource.getRooms();
      try {
        final roomDto = cachedRooms.firstWhere((r) => r.id == roomId);
        return roomDto.toEntity();
      } catch (_) {
        return null;
      }
    }
  }

  @override
  Future<List<Room>> searchRooms(String query) async {
    final rooms = await getRooms();
    final lowerQuery = query.toLowerCase().trim();
    
    if (lowerQuery.isEmpty) {
      return rooms;
    }

    return rooms.where((room) {
      // Поиск по названию
      if (room.title.toLowerCase().contains(lowerQuery)) {
        return true;
      }
      
      // Поиск по удобствам
      for (var amenity in room.amenities) {
        if (amenity.toLowerCase().contains(lowerQuery)) {
          return true;
        }
      }
      
      // Поиск по цене (если введено число)
      try {
        final queryPrice = double.parse(lowerQuery);
        if (room.price <= queryPrice) {
          return true;
        }
      } catch (e) {
        // Не число, игнорируем
      }
      
      return false;
    }).toList();
  }

  @override
  Future<void> refreshRooms() async {
    try {
      final remoteRooms = await _remoteDataSource.getRooms();
      await _localDataSource.saveRooms(remoteRooms);
    } catch (e) {
      // Очищаем кэш при ошибке обновления
      await _localDataSource.clearRooms();
      rethrow;
    }
  }
}
