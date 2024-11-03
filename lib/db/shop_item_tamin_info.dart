import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'shop_item_tamin_info.g.dart';

@HiveType(typeId: SHOP_ITEM_HIVE_ID)
class ShopItemTaminInfo {
  @HiveField(1)
  double amount;
  @HiveField(2)
  String name;
  @HiveField(3)
  double price;
  @HiveField(4)
  String description;
  @HiveField(5)
  double deposit;

  ShopItemTaminInfo(
      {this.amount = 0.0,
      this.name = "",
      this.price = 0.0,
      this.deposit = 0.0,
      this.description = ""});

  factory ShopItemTaminInfo.fromJson(Map<String, dynamic> data) {
    try {
      return ShopItemTaminInfo(
        amount: data["amount"],
        name: data["supplier_items"],
        price: data["price"],
        description: data["description"],
        deposit: data["deposit"],
      );
    } catch (e) {
      return ShopItemTaminInfo(
        amount: data["amount"],
        name: data["supplier_items"],
        price: data["price"],
        description: data["description"],
        deposit: data["deposit"],
      );
      ;
    }
  }
}
