class ShopItemServerModel {
  String name;
  String id;
  String group;

  ShopItemServerModel(
      {required this.name, required this.id, required this.group});
}

class ShopItemModel {
  String name;
  String id;
  String group;
  String price;

  ShopItemModel(
      {required this.name,
      required this.id,
      required this.group,
      required this.price});
}
