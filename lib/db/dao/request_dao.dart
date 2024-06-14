import 'package:frappe_app/db/request.dart';
import 'package:hive/hive.dart';

class RequestDao {
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

  Future<List<Request>> getAll() async {
    var box = await _open();
    return box.values.toList();
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

  String _key() => "request";
}
