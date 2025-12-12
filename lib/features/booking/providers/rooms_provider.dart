import 'package:json_annotation/json_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/room.dart';

part 'rooms_provider.g.dart';

@JsonEnum()
enum RoomsLoadingState {
  initial,
  loading,
  loaded,
  error,
}

@JsonSerializable()
class RoomsLoadingModel {
  final RoomsLoadingState state;
  final String? errorMessage;

  RoomsLoadingModel({
    required this.state,
    this.errorMessage,
  });

  factory RoomsLoadingModel.fromJson(Map<String, dynamic> json) =>
      _$RoomsLoadingModelFromJson(json);
  Map<String, dynamic> toJson() => _$RoomsLoadingModelToJson(this);
}

List<Room> getRoomsData() {
  return [
    Room(
      id: 'r1',
      title: 'Стандартный однокомнатный',
      price: 50.0,
      beds: 1,
      amenities: ['Wi-Fi', 'Телевизор'],
    ),
    Room(
      id: 'r2',
      title: 'Двухместный улучшенный',
      price: 80.0,
      beds: 2,
      amenities: ['Wi-Fi', 'Кондиционер'],
    ),
    Room(
      id: 'r3',
      title: 'Люкс',
      price: 150.0,
      beds: 2,
      amenities: ['Wi-Fi', 'Кондиционер', 'Мини-бар'],
    ),
    Room(
      id: 'r4',
      title: 'Семейный номер',
      price: 120.0,
      beds: 3,
      amenities: ['Wi-Fi', 'Кондиционер', 'Балкон', 'Детская кроватка'],
    ),
    Room(
      id: 'r5',
      title: 'Президентский люкс',
      price: 300.0,
      beds: 2,
      amenities: [
        'Wi-Fi',
        'Кондиционер',
        'Мини-бар',
        'Джакузи',
        'Панорамные окна',
        'Персональный консьерж'
      ],
    ),
  ];
}

class RoomsState {
  final AsyncValue<List<Room>> rooms;
  final bool sortAscending;
  final Room? selectedRoom;
  final bool isRefreshing;
  final RoomsLoadingState loadingState;
  final String searchQuery;

  RoomsState({
    required this.rooms,
    this.sortAscending = true,
    this.selectedRoom,
    this.isRefreshing = false,
    this.loadingState = RoomsLoadingState.initial,
    this.searchQuery = '',
  });

  RoomsState copyWith({
    AsyncValue<List<Room>>? rooms,
    bool? sortAscending,
    Room? selectedRoom,
    bool? isRefreshing,
    RoomsLoadingState? loadingState,
    String? searchQuery,
  }) {
    return RoomsState(
      rooms: rooms ?? this.rooms,
      sortAscending: sortAscending ?? this.sortAscending,
      selectedRoom: selectedRoom ?? this.selectedRoom,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      loadingState: loadingState ?? this.loadingState,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

@riverpod
class RoomsProvider extends _$RoomsProvider {
  @override
  RoomsState build() {
    Future.microtask(() => _loadRooms());
    return RoomsState(
      rooms: const AsyncValue.loading(),
      sortAscending: true,
      loadingState: RoomsLoadingState.loading,
      searchQuery: '',
    );
  }

  Future<void> _loadRooms() async {
    try {
      state = state.copyWith(
        loadingState: RoomsLoadingState.loading,
        rooms: const AsyncValue.loading(),
      );
      await Future.delayed(const Duration(milliseconds: 500));
      final rooms = getRoomsData();
      state = state.copyWith(
        rooms: AsyncValue.data(rooms),
        loadingState: RoomsLoadingState.loaded,
      );
    } catch (e, stack) {
      state = state.copyWith(
        rooms: AsyncValue.error(e, stack),
        loadingState: RoomsLoadingState.error,
      );
    }
  }

  AsyncValue<List<Room>> getFilteredRooms() {
    final rooms = state.rooms;
    final sortAscending = state.sortAscending;
    final searchQuery = state.searchQuery.toLowerCase().trim();

    return rooms.whenData((roomList) {
      // Фильтрация по поисковому запросу
      var filtered = roomList.where((room) {
        if (searchQuery.isEmpty) return true;
        
        // Поиск по названию
        if (room.title.toLowerCase().contains(searchQuery)) {
          return true;
        }
        
        // Поиск по удобствам
        for (var amenity in room.amenities) {
          if (amenity.toLowerCase().contains(searchQuery)) {
            return true;
          }
        }
        
        // Поиск по цене (если введено число)
        if (searchQuery.isNotEmpty) {
          try {
            final queryPrice = double.parse(searchQuery);
            if (room.price <= queryPrice) {
              return true;
            }
          } catch (e) {
            // Не число, игнорируем
          }
        }
        
        return false;
      }).toList();
      
      // Сортировка
      final sorted = List<Room>.from(filtered);
      sorted.sort((a, b) => sortAscending
          ? a.price.compareTo(b.price)
          : b.price.compareTo(a.price));
      return sorted;
    });
  }

  void toggleSort() {
    state = state.copyWith(sortAscending: !state.sortAscending);
  }

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setSelectedRoom(Room? room) {
    state = state.copyWith(selectedRoom: room);
  }

  Room? getRoomById(String roomId) {
    return state.rooms.whenData((rooms) {
      try {
        return rooms.firstWhere((r) => r.id == roomId);
      } catch (e) {
        return null;
      }
    }).value;
  }

  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true);
    await Future.delayed(const Duration(milliseconds: 800));
    await _loadRooms();
    state = state.copyWith(isRefreshing: false);
  }
}
