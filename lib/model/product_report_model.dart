class ProductReportModel {
  String name;
  String id;
  String lastName;
  String province;

  ProductReportModel(
      {required this.name,
      required this.id,
      required this.lastName,
      required this.province});

  static ProductReportModel fromJson(List<dynamic> values) {
    try {
      return ProductReportModel(
          name: values[0],
          id: values[11],
          lastName: values[13],
          province: values[12]);
    } catch (e) {
      print(e);
      return ProductReportModel(name: "", id: "", lastName: "", province: "");
    }
  }
}
