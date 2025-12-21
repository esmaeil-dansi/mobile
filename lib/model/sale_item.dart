class SaleItem {
  final String itemCode;
  final int quantity;
  final num salePrice;
  final int discount;
  final String purchaseDoc;
  final String itemId;
  final String unit;

  SaleItem({
    this.itemCode = '',
    this.quantity = 0,
    this.salePrice = 0,
    this.discount = 0,
    this.purchaseDoc = '',
    this.itemId = '',
    this.unit = '',
  });

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      itemCode: json['item_code'] ?? '',
      quantity: json['quantity'] ?? 0,
      salePrice: json['saleprice'] ?? 0,
      discount: json['discount'] ?? 0,
      purchaseDoc: json['purchase_doc'] ?? '',
      itemId: json['item_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'quantity': quantity,
      'saleprice': salePrice,
      'discount': discount,
      'purchase_doc': purchaseDoc,
      'item_id': itemId,
    };
  }
}
