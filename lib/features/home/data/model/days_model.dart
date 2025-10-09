import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class DaysResponse extends ApiResponse<DaysModel> {
  DaysResponse({required super.errors, required super.message, required super.data});

  factory DaysResponse.fromJson(Map<String, dynamic> json) {
    return DaysResponse(
      errors: json["payload"]["errors"] != null
          ? DaysModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: DaysModel.fromJson(json["payload"]),
    );
  }
}

class DaysModel extends BaseModel {

  List<String>? daysList;

  DaysModel({this.daysList});

  factory DaysModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> daysJson = json['days'] ?? [];
    List<String> days = daysJson.map((e) => e.toString()).toList();
    return DaysModel(daysList: days);
  }

  Map<String, dynamic> toJson() {
    return {
      'days': daysList,
    };
  }
}
