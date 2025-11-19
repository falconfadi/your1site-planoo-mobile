import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';

class MediaResponse extends ApiResponse<AllMediasModel> {
  MediaResponse({required super.errors, required super.message, required super.data});

  factory MediaResponse.fromJson(Map<String, dynamic> json) {
    return MediaResponse(
      errors: json["payload"]["errors"] != null
          ? AllMediasModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AllMediasModel.fromJson(json["payload"]),
    );
  }
}

class AllMediasModel extends BaseModel {

  List<ImageModel>? mediaList;

  AllMediasModel({this.mediaList});

  AllMediasModel.fromJson(Map<String, dynamic> json) {
    if (json['medias'] != null) {
      mediaList = <ImageModel>[];
      json['medias'].forEach((v) {
        mediaList!.add(ImageModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mediaList != null) {
      data['medias'] = mediaList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

