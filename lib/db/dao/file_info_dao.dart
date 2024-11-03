import 'dart:async';

import 'package:frappe_app/db/file_info.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

class FileInfoDao {
  var _shared = GetIt.I.get<SharedPreferencesHelper>();
  Future<Box<FileInfo>> _open() async {
    try {
      return Hive.openBox<FileInfo>(_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_key());
      return Hive.openBox<FileInfo>(_key());
    }
  }

  Future<void> save(FileInfo info) async {
    var box = await _open();
    box.put(info.time.toString() + info.key, info);
  }

  Future<FileInfo?> get(String key) async {
    try {
      var box = await _open();
      return box.get(key);
    } catch (e) {
      return null;
    }
  }

  String _key() => "${_shared.prefix}filesInfo";
}
