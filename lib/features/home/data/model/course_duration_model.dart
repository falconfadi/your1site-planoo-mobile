import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class CourseDurationResponse extends ApiResponse<CourseDurationModel> {
  CourseDurationResponse({required super.errors, required super.message, required super.data});

  factory CourseDurationResponse.fromJson(Map<String, dynamic> json) {
    return CourseDurationResponse(
      errors: json["payload"]["errors"] != null
          ? CourseDurationModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: CourseDurationModel.fromJson(json["payload"]),
    );
  }
}

class CourseDurationModel extends BaseModel {

  List<int>? courseDurationsList;

  CourseDurationModel({this.courseDurationsList});

  factory CourseDurationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> durationsJson = json['durations'] ?? [];
    List<int> durations = durationsJson.map((e) => e as int).toList();
    return CourseDurationModel(courseDurationsList: durations);
  }

  Map<String, dynamic> toJson() {
    return {
      'durations': courseDurationsList,
    };
  }
}
