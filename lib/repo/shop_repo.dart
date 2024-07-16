import 'package:frappe_app/db/dao/shop_dao.dart';
import 'package:frappe_app/db/shop_info.dart';
import 'package:get_it/get_it.dart';

class ShopRepo {
  var _shopDao = GetIt.I.get<ShopDao>();

  void save(ShopInfo shopInfo) {
    _shopDao.save(shopInfo);
  }

  Future<ShopInfo?> getShopInfo() {
    return _shopDao.get();
  }
}
