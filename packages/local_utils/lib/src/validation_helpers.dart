/// Утилиты для валидации данных
class ValidationHelpers {
  /// Проверяет валидность email адреса
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  /// Проверяет валидность номера телефона (российский формат)
  static bool isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^(\+7|7|8)?[\s\-]?\(?[489][0-9]{2}\)?[\s\-]?[0-9]{3}[\s\-]?[0-9]{2}[\s\-]?[0-9]{2}$');
    return phoneRegex.hasMatch(phone);
  }

  /// Проверяет, что строка содержит только цифры
  static bool isNumeric(String text) {
    return RegExp(r'^\d+$').hasMatch(text);
  }

  /// Проверяет длину строки
  static bool hasMinLength(String text, int minLength) {
    return text.length >= minLength;
  }

  /// Проверяет, что строка не превышает максимальную длину
  static bool hasMaxLength(String text, int maxLength) {
    return text.length <= maxLength;
  }

  /// Проверяет, что строка соответствует заданному диапазону длины
  static bool hasLengthBetween(String text, int minLength, int maxLength) {
    return text.length >= minLength && text.length <= maxLength;
  }
}
