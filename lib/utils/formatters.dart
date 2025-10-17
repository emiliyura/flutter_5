import 'package:intl/intl.dart';

class Formatters {
  static final DateFormat yMd = DateFormat('yyyy-MM-dd');

  static String formatDate(DateTime date) => yMd.format(date);
}


