/// Domain Entity - User
/// Чистая бизнес-модель без зависимостей от Flutter или внешних библиотек
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final DateTime? registrationDate;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    this.registrationDate,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? city,
    DateTime? registrationDate,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      registrationDate: registrationDate ?? this.registrationDate,
    );
  }
}










