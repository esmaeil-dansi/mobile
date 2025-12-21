class PriceCheckResponse {
  bool ok;
  num price;
  num min;
  num max;

  PriceCheckResponse({
    this.ok = false,
    this.price = 0,
    this.min = 0,
    this.max = 0,
  });

  factory PriceCheckResponse.fromJson(Map<String, dynamic> json) {
    return PriceCheckResponse(
      ok: json['ok'] ?? false,
      price: json['price'] ?? 0,
      min: json['min'] ?? 0,
      max: json['max'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ok': ok,
      'price': price,
      'min': min,
      'max': max,
    };
  }
}
