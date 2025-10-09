import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_details_model.dart';

class AllWorkdaysResponse extends ApiResponse<AllWorkdaysModel> {
  AllWorkdaysResponse({required super.errors, required super.message, required super.data});

  factory AllWorkdaysResponse.fromJson(Map<String, dynamic> json) {
    return AllWorkdaysResponse(
      errors: json["payload"]["errors"] != null
          ? AllWorkdaysModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AllWorkdaysModel.fromJson(json["payload"]),
    );
  }
}

class AllWorkdaysModel extends BaseModel {

  List<WorkdayDetailsModel>? workdaysList;

  AllWorkdaysModel({this.workdaysList});

  AllWorkdaysModel.fromJson(Map<String, dynamic> json) {
    if (json['days'] != null) {
      workdaysList = <WorkdayDetailsModel>[];
      json['days'].forEach((v) {
        workdaysList!.add(WorkdayDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (workdaysList != null) {
      data['days'] = workdaysList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

