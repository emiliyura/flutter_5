import '../../domain/repositories/favorites_repository.dart';
import '../database/app_database.dart';

/// Реализация репозитория для работы с избранным с использованием Drift
class FavoritesRepositoryImpl implements FavoritesRepository {
  final AppDatabase _db;

  FavoritesRepositoryImpl(this._db);

  @override
  Future<Set<String>> getFavoriteRoomIds() async {
    final favorites = await _db.getAllFavorites();
    return favorites.map((f) => f.roomId).toSet();
  }

  @override
  Future<void> addToFavorites(String roomId) async {
    final isFav = await _db.isRoomFavorite(roomId);
    if (!isFav) {
      await _db.addFavorite(roomId);
    }
  }

  @override
  Future<void> removeFromFavorites(String roomId) async {
    await _db.removeFavorite(roomId);
  }

  @override
  Future<void> toggleFavorite(String roomId) async {
    final isFav = await _db.isRoomFavorite(roomId);
    if (isFav) {
      await _db.removeFavorite(roomId);
    } else {
      await _db.addFavorite(roomId);
    }
  }

  @override
  Future<bool> isFavorite(String roomId) async {
    return await _db.isRoomFavorite(roomId);
  }
}
