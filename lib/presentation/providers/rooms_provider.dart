import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/di/app_module.dart' show getIt;
import '../../domain/entities/room.dart';
import '../../domain/usecases/get_rooms_usecase.dart';

part 'rooms_provider.g.dart';

/// Состояние для списка номеров в UI
class RoomsState {
  final List<Room> rooms;
  final bool isLoading;
  final String? error;
  final bool sortAscending;
  final String searchQuery;

  RoomsState({
    this.rooms = const [],
    this.isLoading = false,
    this.error,
    this.sortAscending = true,
    this.searchQuery = '',
  });

  RoomsState copyWith({
    List<Room>? rooms,
    bool? isLoading,
    String? error,
    bool? sortAscending,
    String? searchQuery,
  }) {
    return RoomsState(
      rooms: rooms ?? this.rooms,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      sortAscending: sortAscending ?? this.sortAscending,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Провайдер для управления состоянием номеров
@riverpod
class RoomsNotifier extends _$RoomsNotifier {
  @override
  RoomsState build() {
    _loadRooms();
    return RoomsState();
  }

  Future<void> _loadRooms() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final useCase = getIt<GetRoomsUseCase>();
      final rooms = await useCase();
      
      state = state.copyWith(
        rooms: rooms,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    await _loadRooms();
  }

  void toggleSort() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  List<Room> getFilteredRooms() {
    var filtered = state.rooms;

    // Фильтрация по поисковому запросу
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered.where((room) {
        if (room.title.toLowerCase().contains(query)) return true;
        for (var amenity in room.amenities) {
          if (amenity.toLowerCase().contains(query)) return true;
        }
        return false;
      }).toList();
    }

    // Сортировка
    final sorted = List<Room>.from(filtered);
    sorted.sort((a, b) => state.sortAscending
        ? a.price.compareTo(b.price)
        : b.price.compareTo(a.price));

    return sorted;
  }
}
