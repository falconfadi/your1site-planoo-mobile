import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/court/court_details_model.dart';

class AllCourtsResponse extends ApiResponse<AllCourtsModel> {
  AllCourtsResponse({required super.errors, required super.message, required super.data});

  factory AllCourtsResponse.fromJson(Map<String, dynamic> json) {
    return AllCourtsResponse(
      errors: json["payload"]["errors"] != null
          ? AllCourtsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AllCourtsModel.fromJson(json["payload"]),
    );
  }
}

class AllCourtsModel extends BaseModel {

  List<CourtDetailsModel>? courtsList;

  AllCourtsModel({this.courtsList});

  AllCourtsModel.fromJson(Map<String, dynamic> json) {
    if (json['activities'] != null) {
      courtsList = <CourtDetailsModel>[];
      json['activities'].forEach((v) {
        courtsList!.add(CourtDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (courtsList != null) {
      data['activities'] = courtsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

