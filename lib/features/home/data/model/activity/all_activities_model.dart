import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_details_model.dart';

class AllActivitiesResponse extends ApiResponse<AllActivitiesModel> {
  AllActivitiesResponse({required super.errors, required super.message, required super.data});

  factory AllActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return AllActivitiesResponse(
      errors: json["payload"]["errors"] != null
          ? AllActivitiesModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AllActivitiesModel.fromJson(json["payload"]),
    );
  }
}

class AllActivitiesModel extends BaseModel {

  List<ActivityDetailsModel>? activitiesList;

  AllActivitiesModel({this.activitiesList});

  AllActivitiesModel.fromJson(Map<String, dynamic> json) {
    if (json['activities'] != null) {
      activitiesList = <ActivityDetailsModel>[];
      json['activities'].forEach((v) {
        activitiesList!.add(ActivityDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (activitiesList != null) {
      data['activities'] = activitiesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

