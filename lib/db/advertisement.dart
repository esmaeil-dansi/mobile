import 'package:hive/hive.dart';

part 'advertisement.g.dart';

@HiveType(typeId: 4)
class Advertisement {
  @HiveField(0)
  String date;

  @HiveField(1)
  List<String> title;

  @HiveField(2)
  List<String> body;

  Advertisement({
    required this.date,
    required this.title,
    required this.body,
  });
}
