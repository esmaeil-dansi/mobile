import 'package:frappe_app/utils/constants.dart';
import 'package:hive/hive.dart';

part 'cart.g.dart';

@HiveType(typeId: CART_HIVE_ID)
class Cart {
  @HiveField(0)
  int time;

  @HiveField(1)
  String shopId;

  @HiveField(5)
  String shopOwner;

  @HiveField(2)
  String item;

  @HiveField(3)
  double amount;

  @HiveField(4)
  double price;

  Cart(
      {required this.time,
      required this.shopId,
      required this.item,
      required this.shopOwner,
      required this.amount,
      required this.price});
}
