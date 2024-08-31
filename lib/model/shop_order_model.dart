class ShopOrderModel {
  String name;
  String shopName;
  String time;
  String status;
  String paymentType;

  ShopOrderModel(
      {required this.name,
      required this.shopName,
      required this.time,
      required this.paymentType,
      required this.status});

  static ShopOrderModel fromJson(Map<String, dynamic> json) {
    return ShopOrderModel(
        name: json["name"],
        status: json["status"] ?? "",
        paymentType: json["payment_type"] ?? "پرداخت از اعتبار",
        shopName: json["store_name"] ?? json["name_buyer"],
        time: json["creation"]);
  }
}
