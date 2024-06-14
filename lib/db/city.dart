
import 'package:hive/hive.dart';

part 'city.g.dart';

@HiveType(typeId: 2)
class City {
  @HiveField(0)
  String name;

  @HiveField(1)
  String id;

  @HiveField(2)
  String province;

  City({
    required this.name,
    required this.id,
    required this.province,
  });
}
