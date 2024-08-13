import 'package:frappe_app/db/request_statuse.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'request.g.dart';

@HiveType(typeId: REQUEST_HIVE_ID)
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

  Map<String, dynamic> toJson() => {
        'time': this.time,
        'body': this.body,
        'type': this.type,
        'status': this.status.name,
        'nationId': this.nationId,
        'filePaths': this.filePaths,
      };

  static Request? fromJson(dynamic data) {
    try {
      return Request(
          time: data["time"],
          type: data["type"],
          nationId: data["nationId"],
          filePaths: ((data["filePaths"] ?? []) as List<dynamic>)
              .map((e) => e.toString())
              .toList(),
          status: RequestStatus.values
              .where((element) => element.name == data["status"])
              .first,
          body: data["body"]);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
