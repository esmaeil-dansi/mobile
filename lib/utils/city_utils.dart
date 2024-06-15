class CityUtils {
  static List<String> extract(List<dynamic> values) {
    var res = <String>[];
    values.forEach((element) {
      res.add(element[11]);
    });
    return res;
  }
}
