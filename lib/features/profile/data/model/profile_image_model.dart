import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class ProfileImageResponse extends ApiResponse<ProfileImageModel> {

  ProfileImageResponse({required super.errors, required super.message, required super.data});

  factory ProfileImageResponse.fromJson(Map<String, dynamic> json) {
    return ProfileImageResponse(
      errors: json["payload"]["errors"] != null
          ? ProfileImageModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: ProfileImageModel.fromJson(json["payload"]),
    );
  }
}

// ignore: must_be_immutable
class ProfileImageModel extends BaseModel{

  ImageModel? profileImageModel;

  ProfileImageModel({
    this.profileImageModel,
  });

  ProfileImageModel.fromJson(Map<String, dynamic> json) {
    profileImageModel = json['profile_image'] != null ? ImageModel.fromJson(json['profile_image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (profileImageModel != null) {
      data['profile_image'] = profileImageModel!.toJson();
    }
    return data;
  }
}

class ImageModel {

  int? id;
  String? url;
  String? type;
  String? name;

  ImageModel({
    this.id,
    this.url,
    this.type,
    this.name
  });

  ImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    type = json['type'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['url'] = url;
    data['type'] = type;
    data['name'] = name;
    return data;
  }
}