class StoreKeeper {
  String id;
  String name;

  StoreKeeper({required this.id, required this.name});

  factory StoreKeeper.fromJson(dynamic data) {
    return StoreKeeper(id: data[0]["supplier_name"], name: data[0]["name"]);
  }
}
