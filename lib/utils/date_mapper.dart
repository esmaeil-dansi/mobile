import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class DateMapper {
  static String convert(String d) {
    try {
      return Jalali.fromDateTime(DateTime.parse(d))
          .formatCompactDate()
          .toString();
    } catch (e) {
      return "";
    }
  }
}
