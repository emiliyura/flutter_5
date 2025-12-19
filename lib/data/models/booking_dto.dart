import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/booking.dart';

part 'booking_dto.g.dart';

/// DTO (Data Transfer Object) для Booking
/// Используется для сериализации/десериализации данных из внешних источников
@JsonSerializable()
class BookingDto {
  final String id;
  @JsonKey(name: 'room_id')
  final String roomId;
  @JsonKey(name: 'guest_name')
  final String guestName;
  @JsonKey(name: 'check_in')
  final DateTime checkIn;
  @JsonKey(name: 'check_out')
  final DateTime checkOut;

  BookingDto({
    required this.id,
    required this.roomId,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
  });

  factory BookingDto.fromJson(Map<String, dynamic> json) => _$BookingDtoFromJson(json);
  Map<String, dynamic> toJson() => _$BookingDtoToJson(this);

  /// Преобразование DTO в Domain Entity
  Booking toEntity() {
    return Booking(
      id: id,
      roomId: roomId,
      guestName: guestName,
      checkIn: checkIn,
      checkOut: checkOut,
    );
  }

  /// Создание DTO из Domain Entity
  factory BookingDto.fromEntity(Booking booking) {
    return BookingDto(
      id: booking.id,
      roomId: booking.roomId,
      guestName: booking.guestName,
      checkIn: booking.checkIn,
      checkOut: booking.checkOut,
    );
  }
}










