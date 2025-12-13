// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingDto _$BookingDtoFromJson(Map<String, dynamic> json) => BookingDto(
  id: json['id'] as String,
  roomId: json['room_id'] as String,
  guestName: json['guest_name'] as String,
  checkIn: DateTime.parse(json['check_in'] as String),
  checkOut: DateTime.parse(json['check_out'] as String),
);

Map<String, dynamic> _$BookingDtoToJson(BookingDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'room_id': instance.roomId,
      'guest_name': instance.guestName,
      'check_in': instance.checkIn.toIso8601String(),
      'check_out': instance.checkOut.toIso8601String(),
    };
