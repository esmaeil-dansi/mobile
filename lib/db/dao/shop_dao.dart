import 'dart:async';

import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/db/transaction_state.dart';
import 'package:frappe_app/utils/SharedPreferenceHelper.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

class ShopDao {
  var _shared = GetIt.I.get<SharedPreferencesHelper>();

  Future<Box<ShopInfo>> _open() async {
    try {
      return Hive.openBox<ShopInfo>(_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_key());
      return Hive.openBox<ShopInfo>(_key());
    }
  }

  Future<Box<TransactionState>> _openTransaction() async {
    try {
      return Hive.openBox<TransactionState>(_transaction_key());
    } catch (e) {
      await Hive.deleteBoxFromDisk(_transaction_key());
      return Hive.openBox<TransactionState>(_transaction_key());
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

  Future<List<ShopInfo>> getAll() async {
    try {
      var box = await _open();
      return box.values.toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveTransaction(String code, String verification,
      {bool close = false}) async {
    try {
      TransactionState transactionState = TransactionState(
          code: code, verificationCode: verification, closed: close);
      var box = await _openTransaction();
      return box.put(code, transactionState);
    } catch (_) {}
  }

  Future<TransactionState?> getTransaction(String code) async {
    try {
      var box = await _openTransaction();
      return box.get(code);
    } catch (e) {
      return null;
    }
  }

  String _key() => "${_shared.prefix}shop_infos";

  String _transaction_key() => "${_shared.prefix}_transaction_key_1";

  Future<void> deleteAll() async {
    try {
      var box = await _open();
      await box.clear();
    } catch (e) {}
  }
}
