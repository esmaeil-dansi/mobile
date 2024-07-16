
import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'file_info.g.dart';

@HiveType(typeId: FILE_INFO_HIVE_ID)
class FileInfo {
  @HiveField(0)
  int time;

  @HiveField(1)
  String key;

  @HiveField(2)
  String path;

  FileInfo({
    required this.time,
    required this.key,
    required this.path,
  });
}
