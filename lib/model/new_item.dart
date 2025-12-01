class NewItem {
  String itemCode;
  String description;
  int quantity;
  double minPrice;
  double maxPrice;
  String breed;
  String pregnancy;
  bool withLamb;

  NewItem({
    this.itemCode = '',
    this.description = '',
    this.quantity = 0,
    this.minPrice = 0.0,
    this.maxPrice = 0.0,
    this.breed = '',
    this.pregnancy = '',
    this.withLamb = false,
  });

  factory NewItem.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return NewItem();
    }

    return NewItem(
      itemCode: json['item_code'] ?? '',
      description: json['description'] ?? '',
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      minPrice: (json['min_price'] as num?)?.toDouble() ?? 0.0,
      maxPrice: (json['max_price'] as num?)?.toDouble() ?? 0.0,
      breed: json['breed'] ?? '',
      pregnancy: json['pregnancy'] ?? '',
      withLamb: json['with_lamb'] == 1 || json['with_lamb'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'item_code': itemCode,
      'description': description,
      'quantity': quantity,
      'min_price': minPrice,
      'max_price': maxPrice,
      'breed': breed,
      'pregnancy': pregnancy,
      'with_lamb': withLamb ? 1 : 0,
    };
  }
}

class SupplierRequest {
  final String username;
  final String password;
  final String supplierId;
  final String warehouse;
  final List<NewItem> items;

  SupplierRequest({
    required this.username,
    required this.password,
    required this.supplierId,
    required this.warehouse,
    required this.items,
  });

  factory SupplierRequest.fromJson(Map<String, dynamic> json) {
    return SupplierRequest(
      username: json['username'],
      password: json['password'],
      supplierId: json['supplier_id'],
      warehouse: json['warehouse'],
      items: (json['items'] as List)
          .map((e) => NewItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'supplier_id': supplierId,
      'warehouse': warehouse,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

