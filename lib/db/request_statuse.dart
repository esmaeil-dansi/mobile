import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'request_statuse.g.dart';

@HiveType(typeId: REQUEST_STATUS_HIVE_ID)
enum RequestStatus {
  @HiveField(2)
  Pending,
  @HiveField(1)
  Success
}
