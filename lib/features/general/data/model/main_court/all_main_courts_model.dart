import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/general/data/model/main_court/main_court_details_model.dart';

class AllMainCourtsResponse extends ApiResponse<AllMainCourtsModel> {
  AllMainCourtsResponse({required super.errors, required super.message, required super.data});

  factory AllMainCourtsResponse.fromJson(Map<String, dynamic> json) {
    return AllMainCourtsResponse(
      errors: json["payload"]["errors"] != null
          ? AllMainCourtsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AllMainCourtsModel.fromJson(json["payload"]),
    );
  }
}

class AllMainCourtsModel extends BaseModel {

  List<MainCourtDetailsModel>? courtsList;

  AllMainCourtsModel({this.courtsList});

  AllMainCourtsModel.fromJson(Map<String, dynamic> json) {
    if (json['courts'] != null) {
      courtsList = <MainCourtDetailsModel>[];
      json['courts'].forEach((v) {
        courtsList!.add(MainCourtDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (courtsList != null) {
      data['courts'] = courtsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

