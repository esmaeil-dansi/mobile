class StoreData {
  final String storeName;
  final String id;

  StoreData({
    required this.storeName,
    required this.id,
  });

  factory StoreData.fromJson(Map<String, dynamic> json) {
    return StoreData(
      storeName: json['store_name'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store_name': storeName,
      'id': id,
    };
  }
}
