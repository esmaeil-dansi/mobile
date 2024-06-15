class Report {
  String id;
  String full_name;
  String time;
  String province;
  String city;
  String email;
  String title;

  Report(this.id, this.full_name, this.time, this.province, this.city,
      this.email, this.title);

  static Report fromJson(List<dynamic> values) {
    return Report(values[0], values[11], values[2], values[12],
        values[13] ?? "", values[1], values[15]);
  }
}

class PeriodicReport {
  String id;
  String full_name;
  String nationId;
  String province;
  String city;
  String email;
  String title;

  PeriodicReport(this.id, this.full_name, this.nationId, this.province,
      this.city, this.email, this.title);

  static PeriodicReport fromJson(List<dynamic> values) {
    return PeriodicReport(values[0], values[3], values[2], values[4], values[5],
        values[1].toString(), values[6]);
  }
}

class VetVisitReport {
  String id;
  String full_name;
  String r_full_name;
  String? time;
  String? province;
  String? city;
  String? email;
  String title;

  VetVisitReport(this.id, this.full_name, this.r_full_name, this.title);

  static VetVisitReport fromJson(List<dynamic> values) {
    return VetVisitReport(values[0], values[11], values[13], values[12]);
  }
}
