class BuyerInfo {
  final String fullName;
  final String province;
  final String city;
  final String nationalId;
  final double customRemainLoan;
  final String mobile;

  BuyerInfo({
    required this.fullName,
    required this.province,
    required this.city,
    required this.nationalId,
    required this.customRemainLoan,
    required this.mobile,
  });

  factory BuyerInfo.fromJson(Map<String, dynamic> json) {
    return BuyerInfo(
      fullName: json['full_name'] as String,
      province: json['province'] as String,
      city: json['city'] as String,
      nationalId: json['national_id'] as String,
      customRemainLoan: (json['custom_remain_loan'] as num).toDouble(),
      mobile: json['mobile'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'province': province,
      'city': city,
      'national_id': nationalId,
      'custom_remain_loan': customRemainLoan,
      'mobile': mobile,
    };
  }
}
