import 'package:frappe_app/db/request_statuse.dart';
import 'package:hive/hive.dart';

part 'request.g.dart';

@HiveType(typeId: 1)
class Request {
  @HiveField(0)
  int time;

  @HiveField(1)
  String body;

  @HiveField(2)
  String type;

  @HiveField(3)
  RequestStatus status;

  @HiveField(5)
  String nationId;

  @HiveField(4)
  List<String>? filePaths;

  Request(
      {required this.time,
      required this.type,
      required this.nationId,
      required this.filePaths,
      required this.status,
      required this.body});
}
