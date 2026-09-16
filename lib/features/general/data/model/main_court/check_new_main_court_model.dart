import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class CheckNewMainCourtResponse extends ApiResponse<CheckNewMainCourtModel> {

  CheckNewMainCourtResponse({required super.errors, required super.message, required super.data});

  factory CheckNewMainCourtResponse.fromJson(Map<String, dynamic> json) {
    return CheckNewMainCourtResponse(
      errors: json["payload"]["errors"] != null
          ? CheckNewMainCourtModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: CheckNewMainCourtModel.fromJson(json["payload"]),
    );
  }
}

class CheckNewMainCourtModel extends BaseModel {

  bool? hasCourt;

  CheckNewMainCourtModel({this.hasCourt});

  CheckNewMainCourtModel.fromJson(Map<String, dynamic> json) {
    hasCourt = json['hasCourt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hasCourt'] = this.hasCourt;
    return data;
  }
}
