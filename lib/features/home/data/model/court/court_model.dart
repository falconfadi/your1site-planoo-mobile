import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/court/court_details_model.dart';

class CourtResponse extends ApiResponse<CourtModel> {
  CourtResponse({required super.errors, required super.message, required super.data});

  factory CourtResponse.fromJson(Map<String, dynamic> json) {
    return CourtResponse(
      errors: json["payload"]["errors"] != null
          ? CourtModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: CourtModel.fromJson(json["payload"]),
    );
  }
}

class CourtModel extends BaseModel {

  CourtDetailsModel? court;

  CourtModel({this.court});

  CourtModel.fromJson(Map<String, dynamic> json) {
    court = json['activity'] != null ? CourtDetailsModel.fromJson(json['activity']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (court != null) {
      data['activity'] = court!.toJson();
    }
    return data;
  }
}

