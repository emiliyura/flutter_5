import 'package:json_annotation/json_annotation.dart';

part 'booking.g.dart';

@JsonSerializable()
class Booking {
  final String id;
  final String roomId;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;

  Booking({
    required this.id,
    required this.roomId,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
  });

  factory Booking.fromJson(Map<String, dynamic> json) => _$BookingFromJson(json);
  Map<String, dynamic> toJson() => _$BookingToJson(this);
}


