class ShopItemBaseModel {
  String name;
  String unit;
  double minPrice;
  double maxPrice;
  String damType;

  ShopItemBaseModel(
      {this.name = "",
      this.unit = "",
      this.damType = "",
      this.maxPrice = 0,
      this.minPrice = 0});



  factory ShopItemBaseModel.fromJson(Map<String, dynamic> json) {
    return ShopItemBaseModel(
      name: json['item_name'] ?? '',
      unit: json['uom'] ?? '',
      minPrice: (json['minprice'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['maxprice'] as num?)?.toDouble() ?? 0.0,
      damType: json['dam_type'] ?? '',
    );
  }
}
