
import 'package:frappe_app/db/shop_item_tamin_info.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'shop_info.g.dart';

@HiveType(typeId: SHOP_INFO_HIVE_ID)
class ShopInfo {
  @HiveField(1)
  String name;

  @HiveField(2)
  String id;

  @HiveField(6)
  List<ShopItemTaminInfo> items;

  ShopInfo({
    required this.name,
    required this.id,
    required this.items,
  });
}
