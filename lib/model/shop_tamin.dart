class ShopTamin {
  String parent;
  double amount;
  double price;
  String description;
  String custom_province;

  ShopTamin(
      {required this.price,
      required this.amount,
      required this.parent,
      required this.custom_province,
      required this.description});

  static ShopTamin? fromJson(Map<String, dynamic> data) {
    try {
      return ShopTamin(
          price: data["price"],
          amount: data["amount"],
          parent: data["parent"],
          custom_province: data["custom_province"],
          description: data["description"]);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
