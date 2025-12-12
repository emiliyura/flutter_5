// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Booking _$BookingFromJson(Map<String, dynamic> json) => Booking(
  id: json['id'] as String,
  roomId: json['roomId'] as String,
  guestName: json['guestName'] as String,
  checkIn: DateTime.parse(json['checkIn'] as String),
  checkOut: DateTime.parse(json['checkOut'] as String),
);

Map<String, dynamic> _$BookingToJson(Booking instance) => <String, dynamic>{
  'id': instance.id,
  'roomId': instance.roomId,
  'guestName': instance.guestName,
  'checkIn': instance.checkIn.toIso8601String(),
  'checkOut': instance.checkOut.toIso8601String(),
};
