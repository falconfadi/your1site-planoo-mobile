import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class RegisterResponse extends ApiResponse<RegisterModel> {

  RegisterResponse({required super.errors, required super.message, required super.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      errors: json["payload"]["errors"] != null
          ? RegisterModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: RegisterModel.fromJson(json["payload"]),
    );
  }
}

// ignore: must_be_immutable
class RegisterModel extends BaseModel{

  int? code;

  RegisterModel({
    this.code
  });

  RegisterModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    return data;
  }
}


