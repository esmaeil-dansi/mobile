class InventoryItem {
  final String itemCode;
  final String warehouse;
  final String customProvince;
  final double currentActualQty;

  InventoryItem({
    required this.itemCode,
    required this.warehouse,
    required this.customProvince,
    required this.currentActualQty,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      itemCode: json['item_code'] ?? '',
      warehouse: json['warehouse'] ?? '',
      customProvince: json['custom_province'] ?? '',
      currentActualQty: (json['current_actual_qty'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'warehouse': warehouse,
      'custom_province': customProvince,
      'current_actual_qty': currentActualQty,
    };
  }
}
