import 'package:frappe_app/db/cart.dart';
import 'package:frappe_app/db/dao/cart_dao.dart';
import 'package:frappe_app/db/dao/shop_dao.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:frappe_app/db/transaction_state.dart';
import 'package:get_it/get_it.dart';

class ShopRepo {
  final _shopDao = GetIt.I.get<ShopDao>();
  final _cartDao = GetIt.I.get<CartDao>();

  Stream<Map<String, Cart>> watchCarts() => _cartDao.watch();

  void saveCart(Cart cart) {
    _cartDao.save(cart);
  }

  void deleteCart(String id) {
    _cartDao.delete(id);
  }

  Future<TransactionState?> getTransactionState(String id) =>
      _shopDao.getTransaction(id);

  Future<void> saveTransaction(String id, String verification,
          {bool close = false}) =>
      _shopDao.saveTransaction(id, verification, close: close);

  void deleteAllCarts() {
    _cartDao.deleteAll();
  }

  Future<void> deleteAllSShop() {
    return _shopDao.deleteAll();
  }

  void save(ShopInfo shopInfo) {
    _shopDao.save(shopInfo);
  }

  Future<List<ShopInfo>> getAll() {
    return _shopDao.getAll();
  }

  Stream<List<ShopInfo>> watchAll() => _shopDao.watchAll();
}
