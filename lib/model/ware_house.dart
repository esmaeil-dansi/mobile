class WarehouseItem {
  String warehouseName;
  String name;

  WarehouseItem({
    this.warehouseName = '',
    this.name = '',
  });

  factory WarehouseItem.fromJson(Map<String, dynamic> json) {
    return WarehouseItem(
      warehouseName: json['warehouse_name'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'warehouse_name': warehouseName,
      'name': name,
    };
  }
}
