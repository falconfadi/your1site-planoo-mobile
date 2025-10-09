import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_details_model.dart';

class WorkdayResponse extends ApiResponse<WorkdayModel> {
  WorkdayResponse({required super.errors, required super.message, required super.data});

  factory WorkdayResponse.fromJson(Map<String, dynamic> json) {
    return WorkdayResponse(
      errors: json["payload"]["errors"] != null
          ? WorkdayModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: WorkdayModel.fromJson(json["payload"]),
    );
  }
}

class WorkdayModel extends BaseModel {

  WorkdayDetailsModel? day;

  WorkdayModel({this.day});

  WorkdayModel.fromJson(Map<String, dynamic> json) {
    day = json['day'] != null ? WorkdayDetailsModel.fromJson(json['day']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (day != null) {
      data['day'] = day!.toJson();
    }
    return data;
  }
}

