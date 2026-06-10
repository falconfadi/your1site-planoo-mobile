
class RememberMeModel {

  final String phone;
  final String password;
  final bool rememberMe;

  RememberMeModel({
    required this.phone,
    required this.password,
    required this.rememberMe,
  });

  Map<String, dynamic> toJson() {
    return {
      "phone": phone,
      "password": password,
      "remember_me": rememberMe,
    };
  }

  factory RememberMeModel.fromJson(Map<String, dynamic> json) {
    return RememberMeModel(
      phone: json["phone"] ?? "",
      password: json["password"] ?? "",
      rememberMe: json["remember_me"] ?? true,
    );
  }
}