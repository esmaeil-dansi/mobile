import 'package:frappe_app/db/advertisement.dart';
import 'package:hive/hive.dart';

class AdvertisementDao {
  Future<Box<Advertisement>> _open() async {
    try {
      return Hive.openBox<Advertisement>(_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_key());
      return Hive.openBox<Advertisement>(_key());
    }
  }

  Future<void> save(Advertisement advertisement) async {
    var box = await _open();
    box.put(advertisement.date, advertisement);
  }

  Future<List<Advertisement>> getAll() async {
    var box = await _open();
    return box.values.toList();
  }

  Stream<Advertisement?> watch(String date) async* {
    var box = await _open();
    yield box.get(date);
    yield* box.watch(key: date).map((event) => box.get(date));
  }

  Future<void> delete(int id) async {
    var box = await _open();
    await box.delete(id.toString());
  }

  String _key() => "advertisement";
}
