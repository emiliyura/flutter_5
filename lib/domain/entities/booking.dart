/// Domain Entity - Booking
/// Чистая бизнес-модель без зависимостей от Flutter или внешних библиотек
class Booking {
  final String id;
  final String roomId;
  final String guestName;
  final DateTime checkIn;
  final DateTime checkOut;

  const Booking({
    required this.id,
    required this.roomId,
    required this.guestName,
    required this.checkIn,
    required this.checkOut,
  });

  Booking copyWith({
    String? id,
    String? roomId,
    String? guestName,
    DateTime? checkIn,
    DateTime? checkOut,
  }) {
    return Booking(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      guestName: guestName ?? this.guestName,
      checkIn: checkIn ?? this.checkIn,
      checkOut: checkOut ?? this.checkOut,
    );
  }
}
