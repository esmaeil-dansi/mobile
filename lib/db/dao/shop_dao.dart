import 'dart:async';

import 'package:frappe_app/db/shop_info.dart';
import 'package:hive/hive.dart';

class ShopDao {
  Future<Box<ShopInfo>> _open() async {
    try {
      return Hive.openBox<ShopInfo>(_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_key());
      return Hive.openBox<ShopInfo>(_key());
    }
  }

  Future<void> save(ShopInfo info) async {
    var box = await _open();
    box.put(info.id, info);
  }

  Stream<List<ShopInfo>> watchAll() async* {
    var box = await _open();

    yield box.values.toList();

    yield* box.watch().map((event) => box.values.toList());
  }

  Future<ShopInfo?> get() async {
    try {
      var box = await _open();
      return box.get(_my_key());
    } catch (e) {
      return null;
    }
  }

  String _key() => "shop_infos_1";

  String _my_key() => "shop_info_key_1";

  Future<void> deleteAll() async {
    try {
      var box = await _open();
      await box.clear();
    } catch (e) {}
  }
}
