class ShopOrderModel {
  String name;
  String shopName;
  String time;
  String status;

  ShopOrderModel(
      {required this.name,
      required this.shopName,
      required this.time,
      required this.status});

  static ShopOrderModel fromJson(Map<String, dynamic> json) {
    return ShopOrderModel(
        name: json["name"],
        status: json["status"] ?? "",
        shopName: json["store_name"] ?? json["name_buyer"],
        time: json["creation"]);
  }
}
