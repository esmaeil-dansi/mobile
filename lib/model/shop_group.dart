import 'package:frappe_app/model/shop_type.dart';

class ShopGroup {
  ShopType type;
  String asset;

  ShopGroup(this.type, this.asset);
}

class ShopItemType {
  String title;
  String asset;
  String price;

  ShopItemType(this.title, this.asset, this.price);
}
