class SalesItemModel {
  final String itemName;
  final String uom;
  final double minPrice;
  final double maxPrice;
  final String damType;

  SalesItemModel({
    required this.itemName,
    required this.uom,
    required this.minPrice,
    required this.maxPrice,
    required this.damType,
  });

  factory SalesItemModel.fromJson(Map<String, dynamic> json) {
    return SalesItemModel(
      itemName: json['item_name'] as String,
      uom: json['uom'] as String,
      minPrice: (json['minprice'] as num).toDouble(),
      maxPrice: (json['maxprice'] as num).toDouble(),
      damType:json["dam_type"]!= null?json["dam_type"]:"",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_name': itemName,
      'uom': uom,
      'minprice': minPrice,
      'maxprice': maxPrice,
      'dam_type': damType,
    };
  }
}
