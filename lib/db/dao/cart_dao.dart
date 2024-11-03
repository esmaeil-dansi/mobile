import 'dart:async';

import 'package:frappe_app/db/cart.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import '../../utils/SharedPreferenceHelper.dart';

class CartDao {
  var _shared = GetIt.I.get<SharedPreferencesHelper>();

  Future<Box<Cart>> _open() async {
    try {
      return Hive.openBox<Cart>(_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_key());
      return Hive.openBox<Cart>(_key());
    }
  }

  Future<void> save(Cart cart) async {
    var box = await _open();
    box.put(_getId(cart), cart);
  }

  Stream<Map<String, Cart>> watch() async* {
    var box = await _open();
    yield _map(_sorted(box.values.toList()));
    yield* box.watch().map((event) => _map(_sorted(box.values.toList())));
  }

  Map<String, Cart> _map(List<Cart> carts) {
    return Map.fromIterable(carts, key: (c) {
      return _getId(c as Cart);
    }, value: (c) {
      return c;
    });
  }

  List<Cart> _sorted(List<Cart> carts) {
    carts.sort((a, b) => a.time - b.time);
    return carts;
  }

  Future<void> delete(String id) async {
    var box = await _open();
    await box.delete(id);
  }

  Future<void> deleteAll() async {
    var box = await _open();
    await box.clear();
  }

  String _getId(Cart cart) => cart.shopId + cart.item + cart.price.toString();

  String _key() => "${_shared.prefix}carts_db";
}
