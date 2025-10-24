/// Утилиты для работы со строками
class StringHelpers {
  /// Капитализирует первую букву строки
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  /// Капитализирует каждое слово в строке
  static String capitalizeWords(String text) {
    return text.split(' ').map((word) => capitalize(word)).join(' ');
  }

  /// Обрезает строку до указанной длины и добавляет многоточие
  static String truncate(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  /// Проверяет, является ли строка пустой или содержит только пробелы
  static bool isNullOrEmpty(String? text) {
    return text == null || text.trim().isEmpty;
  }

  /// Удаляет лишние пробелы из строки
  static String normalizeSpaces(String text) {
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }
}
