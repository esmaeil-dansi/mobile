class PurchaseItem {
  String purchaseDoc;
  num salePrice;
  num quantity;
  num rate;
  String itemCode;
  String itemId;
  String purchaseDate;
  num remainQuantity;

  PurchaseItem({
    this.purchaseDoc = '',
    this.salePrice = 0,
    this.quantity = 0,
    this.rate = 0,
    this.itemCode = '',
    this.itemId = '',
    this.purchaseDate = '',
    this.remainQuantity = 0,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      purchaseDoc: json['purchase_doc'] ?? '',
      salePrice: json['saleprice'] ?? 0,
      quantity: json['quantity'] ?? 0,
      rate: json['rate'] ?? 0,
      itemCode: json['item_code'] ?? '',
      itemId: json['item_id']?.toString() ?? '',
      purchaseDate: json['purchase_date'] ?? '',
      remainQuantity: json['remain_quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'purchase_doc': purchaseDoc,
      'saleprice': salePrice,
      'quantity': quantity,
      'rate': rate,
      'item_code': itemCode,
      'item_id': itemId,
      'purchase_date': purchaseDate,
      'remain_quantity': remainQuantity,
    };
  }
}
