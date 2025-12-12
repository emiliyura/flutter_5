import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/room.dart';

part 'favorites_provider.g.dart';

@riverpod
class FavoritesProvider extends _$FavoritesProvider {
  @override
  Set<String> build() {
    // Возвращаем Set с ID избранных номеров
    return <String>{};
  }

  bool isFavorite(String roomId) {
    return state.contains(roomId);
  }

  void toggleFavorite(String roomId) {
    final newState = Set<String>.from(state);
    if (newState.contains(roomId)) {
      newState.remove(roomId);
    } else {
      newState.add(roomId);
    }
    state = newState;
  }

  void addToFavorites(String roomId) {
    if (!state.contains(roomId)) {
      state = {...state, roomId};
    }
  }

  void removeFromFavorites(String roomId) {
    if (state.contains(roomId)) {
      final newState = Set<String>.from(state);
      newState.remove(roomId);
      state = newState;
    }
  }

  List<Room> getFavoriteRooms(List<Room> allRooms) {
    return allRooms.where((room) => state.contains(room.id)).toList();
  }
}



