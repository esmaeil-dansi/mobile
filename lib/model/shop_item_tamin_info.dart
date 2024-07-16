class ShopItemTaminInfo {
  String supplier_items;
  String amount;
  String name;

  ShopItemTaminInfo({this.supplier_items = "", this.amount = "",this.name =""});

  static ShopItemTaminInfo? fromJson(dynamic data) {
    try {
      return ShopItemTaminInfo(
          supplier_items: data["supplier_items"], amount: data["amount"]);
    } catch (e) {}
  }
}
