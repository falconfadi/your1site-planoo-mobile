
class CountryCodeModel {

  final String isoCode;
  final String dialCode;

  CountryCodeModel({
    required this.isoCode,
    required this.dialCode,
  });

  Map<String, dynamic> toJson() {
    return {
      "iso_code": isoCode,
      "dial_code": dialCode,
    };
  }

  factory CountryCodeModel.fromJson(Map<String, dynamic> json) {
    return CountryCodeModel(
      isoCode: json["iso_code"] ?? "IQ",
      dialCode: json["dial_code"] ?? "+964",
    );
  }
}