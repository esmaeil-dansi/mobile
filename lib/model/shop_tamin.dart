class ShopTamin {
  String name;
  String owner;
  String supplier_name;
  String? image;
  String supplier_group;
  String custom_provinc;

  ShopTamin(
      {required this.name,
      required this.owner,
      required this.supplier_name,
      required this.supplier_group,
      required this.custom_provinc,
      this.image});

  static ShopTamin? fromJson(List<dynamic> data) {
    try {
      return ShopTamin(
          name: data[0],
          owner: data[1],
          supplier_group: data[13],
          supplier_name: data[11],
          image: data[15],
          custom_provinc: data[14]);
    } catch (e) {
      print(e);
      return null;
    }
  }
}
