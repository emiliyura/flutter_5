import '../../domain/repositories/favorites_repository.dart';

/// Реализация репозитория для работы с избранным
/// Временная реализация с хранением в памяти (для демонстрации)
class FavoritesRepositoryImpl implements FavoritesRepository {
  final Set<String> _favoriteIds = <String>{};

  @override
  Future<Set<String>> getFavoriteRoomIds() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return Set.from(_favoriteIds);
  }

  @override
  Future<void> addToFavorites(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _favoriteIds.add(roomId);
  }

  @override
  Future<void> removeFromFavorites(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _favoriteIds.remove(roomId);
  }

  @override
  Future<void> toggleFavorite(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (_favoriteIds.contains(roomId)) {
      _favoriteIds.remove(roomId);
    } else {
      _favoriteIds.add(roomId);
    }
  }

  @override
  Future<bool> isFavorite(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _favoriteIds.contains(roomId);
  }
}
