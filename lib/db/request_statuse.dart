import 'package:hive/hive.dart';
part 'request_statuse.g.dart';

@HiveType(typeId: 3)
enum RequestStatus {
  @HiveField(2)
  Pending,

  @HiveField(1)
  Success
}
