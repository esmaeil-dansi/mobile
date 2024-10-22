import 'package:flutter/foundation.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DateMapper {
  static String convert(String d) {
    if (kDebugMode) {
      return "1402/02/02";
    }
    try {
      return Jalali.fromDateTime(DateTime.parse(d))
          .formatCompactDate()
          .toString();
    } catch (e) {
      return "";
    }
  }
}
