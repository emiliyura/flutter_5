// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RoomDto _$RoomDtoFromJson(Map<String, dynamic> json) => RoomDto(
  id: json['id'] as String,
  title: json['title'] as String,
  price: (json['price'] as num).toDouble(),
  beds: (json['beds'] as num).toInt(),
  amenities:
      (json['amenities'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  isBooked: json['is_booked'] as bool? ?? false,
);

Map<String, dynamic> _$RoomDtoToJson(RoomDto instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'price': instance.price,
  'beds': instance.beds,
  'amenities': instance.amenities,
  'is_booked': instance.isBooked,
};
