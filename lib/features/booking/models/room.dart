import 'package:json_annotation/json_annotation.dart';

part 'room.g.dart';

@JsonSerializable()
class Room {
  final String id;
  final String title;
  final double price;
  final int beds;
  final List<String> amenities;
  final bool isBooked;

  const Room({
    required this.id,
    required this.title,
    required this.price,
    required this.beds,
    this.amenities = const [],
    this.isBooked = false,
  });

  Room copyWith({bool? isBooked}) {
    return Room(
      id: id,
      title: title,
      price: price,
      beds: beds,
      amenities: amenities,
      isBooked: isBooked ?? this.isBooked,
    );
  }

  factory Room.fromJson(Map<String, dynamic> json) => _$RoomFromJson(json);
  Map<String, dynamic> toJson() => _$RoomToJson(this);
}


