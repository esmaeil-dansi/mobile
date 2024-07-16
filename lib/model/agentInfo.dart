class AgentInfo {
  String name = "";
  String full_name = "";
  String province = "";
  String city = "";
  String address = "";
  String mobile = "";
  String rahbar = "";
  String department = "";
  String nationId = "";

  AgentInfo({
    this.name = "",
    this.rahbar = "",
    this.full_name = "",
    this.province = "",
    this.address = "",
    this.city = "",
    this.mobile = "",
    this.department = "",
  });

  factory AgentInfo.fromJsom(Map<String, dynamic> data) {
    return AgentInfo(
      name: data["name"] ?? '',
      rahbar: data["rahbar"] ?? '',
      full_name: data["full_name"] ?? "",
      address: data["address"] ?? "",
      city: data["city"] ?? '',
      province: data["province"] ?? '',
      mobile: data["mobile"] ?? '',
      department: data["department"] != null ? data["department"] : "",
    );
  }
}
