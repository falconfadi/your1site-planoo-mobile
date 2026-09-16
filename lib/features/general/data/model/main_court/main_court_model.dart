import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/general/data/model/main_court/main_court_details_model.dart';

class MainCourtResponse extends ApiResponse<MainCourtModel> {
  MainCourtResponse({required super.errors, required super.message, required super.data});

  factory MainCourtResponse.fromJson(Map<String, dynamic> json) {
    return MainCourtResponse(
      errors: json["payload"]["errors"] != null
          ? MainCourtModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: MainCourtModel.fromJson(json["payload"]),
    );
  }
}

class MainCourtModel extends BaseModel {

  MainCourtDetailsModel? mainCourt;

  MainCourtModel({this.mainCourt});

  MainCourtModel.fromJson(Map<String, dynamic> json) {
    mainCourt = json['court'] != null ? MainCourtDetailsModel.fromJson(json['court']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mainCourt != null) {
      data['court'] = mainCourt!.toJson();
    }
    return data;
  }
}

