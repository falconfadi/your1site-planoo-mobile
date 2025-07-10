import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/auth/data/model/user_model.dart';

class LoginResponse extends ApiResponse<LoginModel> {

  LoginResponse({required super.errors, required super.message, required super.data});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      errors: json["payload"]["errors"] != null
          ? LoginModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: LoginModel.fromJson(json["payload"]),
    );
  }
}

class LoginModel extends BaseModel{

  UserModel? user;
  String? token;

  LoginModel({
    this.user,
    this.token
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}


