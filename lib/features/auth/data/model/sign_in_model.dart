import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/auth/data/model/user_model.dart';

class SignInResponse extends ApiResponse<SignInModel> {

  SignInResponse({required super.errors, required super.message, required super.data});

  factory SignInResponse.fromJson(Map<String, dynamic> json) {
    return SignInResponse(
      errors: json["payload"]["errors"] != null
          ? SignInModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: SignInModel.fromJson(json["payload"]),
    );
  }
}

// ignore: must_be_immutable
class SignInModel extends BaseModel{

  UserModel? user;
  String? token;

  SignInModel({
    this.user,
    this.token
  });

  SignInModel.fromJson(Map<String, dynamic> json) {
    user = json['user'] != null ? UserModel.fromJson(json['user']) : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (user != null) {
      data['user'] = user!.toJson();
    }
    data['token'] = token;
    return data;
  }
}


