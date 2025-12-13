/// Domain Entity - Room
/// Чистая бизнес-модель без зависимостей от Flutter или внешних библиотек
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

  Room copyWith({
    String? id,
    String? title,
    double? price,
    int? beds,
    List<String>? amenities,
    bool? isBooked,
  }) {
    return Room(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      beds: beds ?? this.beds,
      amenities: amenities ?? this.amenities,
      isBooked: isBooked ?? this.isBooked,
    );
  }
}
