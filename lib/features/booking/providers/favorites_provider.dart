import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/di/app_module.dart' show getIt;
import '../../../domain/repositories/favorites_repository.dart';
import '../models/room.dart';

part 'favorites_provider.g.dart';

@riverpod
class FavoritesProvider extends _$FavoritesProvider {
  FavoritesRepository? _repository;

  @override
  Set<String> build() {
    _repository = getIt<FavoritesRepository>();
    _loadFavorites();
    return <String>{};
  }

  Future<void> _loadFavorites() async {
    try {
      final favorites = await _repository!.getFavoriteRoomIds();
      state = favorites;
    } catch (e) {
      // Игнорируем ошибки загрузки
    }
  }

  bool isFavorite(String roomId) {
    return state.contains(roomId);
  }

  Future<void> toggleFavorite(String roomId) async {
    final newState = Set<String>.from(state);
    if (newState.contains(roomId)) {
      newState.remove(roomId);
      await _repository?.removeFromFavorites(roomId);
    } else {
      newState.add(roomId);
      await _repository?.addToFavorites(roomId);
    }
    state = newState;
  }

  Future<void> addToFavorites(String roomId) async {
    if (!state.contains(roomId)) {
      state = {...state, roomId};
      await _repository?.addToFavorites(roomId);
    }
  }

  Future<void> removeFromFavorites(String roomId) async {
    if (state.contains(roomId)) {
      final newState = Set<String>.from(state);
      newState.remove(roomId);
      state = newState;
      await _repository?.removeFromFavorites(roomId);
    }
  }

  List<Room> getFavoriteRooms(List<Room> allRooms) {
    return allRooms.where((room) => state.contains(room.id)).toList();
  }

  Future<void> refresh() async {
    await _loadFavorites();
  }
}
