import 'package:frappe_app/db/cart.dart';
import 'package:frappe_app/db/dao/cart_dao.dart';
import 'package:frappe_app/db/dao/shop_dao.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:get_it/get_it.dart';

class ShopRepo {
  final _shopDao = GetIt.I.get<ShopDao>();
  final _cartDao = GetIt.I.get<CartDao>();

  Stream<Map<String,Cart>> watchCarts() => _cartDao.watch();

  void saveCart(Cart cart) {
    _cartDao.save(cart);
  }

  void deleteCart(String id) {
    _cartDao.delete(id);
  }

 Future<void> deleteAllSShop() {
    return _shopDao.deleteAll();
  }

  void save(ShopInfo shopInfo) {
    _shopDao.save(shopInfo);
  }

  Future<ShopInfo?> getShopInfo() {
    return _shopDao.get();
  }

  Stream<List<ShopInfo>> watchAll() => _shopDao.watchAll();
}
