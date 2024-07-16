import 'package:frappe_app/db/request_statuse.dart';
import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'shop_info.g.dart';

@HiveType(typeId: SHOP_INFO_HIVE_ID)
class ShopInfo {
  @HiveField(1)
  String name;

  @HiveField(2)
  String id;

  @HiveField(3)
  List<String> items;

  @HiveField(5)
  List<String> items_amount;

  ShopInfo({
    required this.name,
    required this.id,
    required this.items,
    required this.items_amount,
  });
}
