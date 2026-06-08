class ReqAddress {
  double? longitude;
  double? latitude;
  String? line1;
  int? postalCode;
  String? country;
  String? city;
  String? line2;

  ReqAddress(
      {this.longitude,
        this.latitude,
        this.line1,
        this.postalCode,
        this.country,
        this.city,
        this.line2});

  ReqAddress.fromJson(Map<String, dynamic> json) {
    longitude = json['longitude'];
    latitude = json['latitude'];
    line1 = json['line1'];
    postalCode = json['postal_code'];
    country = json['country'];
    city = json['city'];
    line2 = json['line2'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['longitude'] = longitude;
    data['latitude'] = latitude;
    data['line1'] = line1;
    data['postal_code'] = postalCode;
    data['country'] = country;
    data['city'] = city;
    data['line2'] = line2;
    return data;
  }
}
