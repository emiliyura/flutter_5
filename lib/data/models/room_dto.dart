import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/room.dart';

part 'room_dto.g.dart';

/// DTO (Data Transfer Object) для Room
/// Используется для сериализации/десериализации данных из внешних источников
@JsonSerializable()
class RoomDto {
  final String id;
  final String title;
  final double price;
  final int beds;
  final List<String> amenities;
  @JsonKey(name: 'is_booked', defaultValue: false)
  final bool isBooked;

  RoomDto({
    required this.id,
    required this.title,
    required this.price,
    required this.beds,
    this.amenities = const [],
    this.isBooked = false,
  });

  factory RoomDto.fromJson(Map<String, dynamic> json) => _$RoomDtoFromJson(json);
  Map<String, dynamic> toJson() => _$RoomDtoToJson(this);

  /// Преобразование DTO в Domain Entity
  Room toEntity() {
    return Room(
      id: id,
      title: title,
      price: price,
      beds: beds,
      amenities: amenities,
      isBooked: isBooked,
    );
  }

  /// Создание DTO из Domain Entity
  factory RoomDto.fromEntity(Room room) {
    return RoomDto(
      id: room.id,
      title: room.title,
      price: room.price,
      beds: room.beds,
      amenities: room.amenities,
      isBooked: room.isBooked,
    );
  }
}
