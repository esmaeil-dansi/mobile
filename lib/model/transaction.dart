class Transaction {
  String supplier_items;
  int amount;
  int price;
  String description;

  Transaction(
      {required this.supplier_items,
      required this.amount,
      required this.price,
      required this.description});

  Map<String, dynamic> toJson() => {
        'supplier_items': this.supplier_items,
        'amount': this.amount,
        'price': this.price,
        'description': this.description,
      };

  static Transaction fromJson(Map<String, dynamic> json) {
    return new Transaction(
      supplier_items: json["supplier_items"],
      amount: double.parse(json["amount"].toString()).floor(),
      price: double.parse(json["price"].toString()).floor(),
      description: json["description"],
    );
  }
}

class TransactionInfo {
  String store_name;
  String seller_name;
  String name_buyer;
  String id_buyer;
  String seller_phone;
  String status;
  List<Transaction> transactions;

  TransactionInfo(
      {required this.store_name,
      required this.seller_name,
      required this.seller_phone,
        required this.id_buyer,
      required this.name_buyer,
      required this.status,
      required this.transactions});

  static TransactionInfo? fromJson(Map<String, dynamic> json) {
    try {
      return TransactionInfo(
          store_name: json["transdata"][0]["store_name"],
          seller_name: json["transdata"][0]["seller_name"] ?? "",
          seller_phone: json["transdata"][0]["seller_phone"] ?? "",
          name_buyer: json["transdata"][0]["name_buyer"] ?? "",
          id_buyer: json["transdata"][0]["id_buyer"] ?? "",
          status: json["transdata"][0]["status"] ?? "",
          transactions: json["items"] != 0
              ? ((json["items"]) as List<dynamic>)
                  .map((t) => Transaction.fromJson(t))
                  .toList()
              : []);
    } catch (e) {
      print(e);
    }
  }
}
