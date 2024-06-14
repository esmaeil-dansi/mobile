
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
      name: data["name"],
      rahbar: data["راهبر اصلی"],
      full_name: data["نام و نام خانوادگی"],
      address: data["آدرس دقیق"],
      city: data["بخش"],
      province: data["استان"],
      mobile: data["موبایل"],
      department:
          data["اداره کمیته امداد"] != null ? data["اداره کمیته امداد"] : " ",
    );
  }
}
