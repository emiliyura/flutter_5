import 'package:intl/intl.dart';

/// Утилиты для работы с датами
class DateHelpers {
  /// Форматирует дату в читаемый вид
  static String formatDate(DateTime date, {String pattern = 'dd.MM.yyyy'}) {
    return DateFormat(pattern).format(date);
  }

  /// Форматирует время
  static String formatTime(DateTime time, {String pattern = 'HH:mm'}) {
    return DateFormat(pattern).format(time);
  }

  /// Проверяет, является ли дата сегодняшней
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && 
           date.month == now.month && 
           date.day == now.day;
  }

  /// Получает начало дня
  static DateTime startOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Получает конец дня
  static DateTime endOfDay(DateTime date) {
    return DateTime(date.year, date.month, date.day, 23, 59, 59);
  }
}
