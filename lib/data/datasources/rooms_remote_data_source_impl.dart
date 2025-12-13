import '../models/room_dto.dart';
import 'rooms_remote_data_source.dart';

/// Реализация удаленного источника данных для номеров
/// Временная реализация с моковыми данными (для демонстрации)
class RoomsRemoteDataSourceImpl implements RoomsRemoteDataSource {
  // Моковые данные (в реальном приложении здесь будет HTTP запрос)
  final List<RoomDto> _mockRooms = [
    RoomDto(
      id: 'r1',
      title: 'Стандартный однокомнатный',
      price: 50.0,
      beds: 1,
      amenities: ['Wi-Fi', 'Телевизор'],
    ),
    RoomDto(
      id: 'r2',
      title: 'Двухместный улучшенный',
      price: 80.0,
      beds: 2,
      amenities: ['Wi-Fi', 'Кондиционер'],
    ),
    RoomDto(
      id: 'r3',
      title: 'Люкс',
      price: 150.0,
      beds: 2,
      amenities: ['Wi-Fi', 'Кондиционер', 'Мини-бар'],
    ),
    RoomDto(
      id: 'r4',
      title: 'Семейный номер',
      price: 120.0,
      beds: 3,
      amenities: ['Wi-Fi', 'Кондиционер', 'Балкон', 'Детская кроватка'],
    ),
    RoomDto(
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

  @override
  Future<List<RoomDto>> getRooms() async {
    // Имитация сетевого запроса
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockRooms);
  }

  @override
  Future<RoomDto> getRoomById(String roomId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final room = _mockRooms.firstWhere(
      (r) => r.id == roomId,
      orElse: () => throw Exception('Room not found: $roomId'),
    );
    return room;
  }
}
