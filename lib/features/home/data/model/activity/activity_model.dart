import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_details_model.dart';

class ActivityResponse extends ApiResponse<ActivityModel> {
  ActivityResponse({required super.errors, required super.message, required super.data});

  factory ActivityResponse.fromJson(Map<String, dynamic> json) {
    return ActivityResponse(
      errors: json["payload"]["errors"] != null
          ? ActivityModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: ActivityModel.fromJson(json["payload"]),
    );
  }
}

class ActivityModel extends BaseModel {

  ActivityDetailsModel? activity;

  ActivityModel({this.activity});

  ActivityModel.fromJson(Map<String, dynamic> json) {
    activity = json['activity'] != null ? ActivityDetailsModel.fromJson(json['activity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (activity != null) {
      data['activity'] = activity!.toJson();
    }
    return data;
  }
}

