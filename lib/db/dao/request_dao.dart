import 'dart:async';

import 'package:frappe_app/db/request.dart';
import 'package:frappe_app/db/request_statuse.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

class RequestDao {
  var _shared = GetIt.I.get<SharedPreferencesHelper>();

  Future<Box<Request>> _open() async {
    try {
      return Hive.openBox<Request>(_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_key());
      return Hive.openBox<Request>(_key());
    }
  }

  Future<void> save(Request request) async {
    var box = await _open();
    box.put(request.time.toString(), request);
  }

  Future<List<Request>> getAllFailed() async {
    var box = await _open();
    return box.values
        .where((element) => element.status == RequestStatus.Pending)
        .toList();
  }

  Stream<List<Request>> watch() async* {
    var box = await _open();

    yield box.values.toList();

    yield* box.watch().map((event) => box.values.toList());
  }

  Future<void> delete(int id) async {
    var box = await _open();
    await box.delete(id.toString());
  }

  Future<Request?> getByNationIdAndType(String id, String type) async {
    try {
      var box = await _open();
      return box.values
          .where((element) =>
              element.nationId == id &&
              element.type == type &&
              element.status == RequestStatus.Pending)
          .firstOrNull;
    } catch (e) {
      return null;
    }
  }

  String _key() => "${_shared.prefix}requests";
}
