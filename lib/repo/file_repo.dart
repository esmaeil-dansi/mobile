import 'dart:async';
import 'dart:io';

import 'package:frappe_app/db/dao/file_info_dao.dart';
import 'package:frappe_app/db/file_info.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';

class FileRepo {
  var _fileDao = GetIt.I.get<FileInfoDao>();

  Future<String?> saveFile(
      {required int time, required String key, required String path}) async {
    try {
      var file =
          await filePath(time.toString() + key + "." + path.split(".").last);
      var bytes = File(path).readAsBytesSync();
      var t = await file.writeAsBytes(bytes);
      _fileDao.save(FileInfo(time: time, key: key, path: t.path));
      return t.path;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> saveFileInDownloadDir(
      {required int time, required String key, required String path}) async {
    try {
      var file = await downloadPath(
          time.toString() + key + "." + path.split(".").last);
      var bytes = File(path).readAsBytesSync();
      var t = await file.writeAsBytes(bytes);
      return t.path;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> getFile(String key) async {
    return (await _fileDao.get(key))?.path;
  }

  Future<File> filePath(String fileUuid) async {
    final path = "${(await getApplicationDocumentsDirectory()).path}";
    return File('$path/$fileUuid');
  }

  Future<File> downloadPath(String fileUuid) async {
    final path = "/storage/emulated/0/Download";
    await Directory('$path/chopo/files').create(recursive: true);
    return File('$path//chopo/files/$fileUuid');
  }
}
