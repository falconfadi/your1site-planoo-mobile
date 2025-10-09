import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class UserTypeResponse extends ApiResponse<UserTypeModel> {
  UserTypeResponse({required super.errors, required super.message, required super.data});

  factory UserTypeResponse.fromJson(Map<String, dynamic> json) {
    return UserTypeResponse(
      errors: json["payload"]["errors"] != null
          ? UserTypeModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: UserTypeModel.fromJson(json["payload"]),
    );
  }
}

class UserTypeModel extends BaseModel {

  List<String>? userTypesList;

  UserTypeModel({this.userTypesList});

  factory UserTypeModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> typesJson = json['usersTypes'] ?? [];
    List<String> types = typesJson.map((e) => e.toString()).toList();
    return UserTypeModel(userTypesList: types);
  }

  Map<String, dynamic> toJson() {
    return {
      'usersTypes': userTypesList,
    };
  }
}
