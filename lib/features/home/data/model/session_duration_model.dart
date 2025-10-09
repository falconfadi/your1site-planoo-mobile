import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class SessionDurationResponse extends ApiResponse<SessionDurationModel> {
  SessionDurationResponse({required super.errors, required super.message, required super.data});

  factory SessionDurationResponse.fromJson(Map<String, dynamic> json) {
    return SessionDurationResponse(
      errors: json["payload"]["errors"] != null
          ? SessionDurationModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: SessionDurationModel.fromJson(json["payload"]),
    );
  }
}

class SessionDurationModel extends BaseModel {

  List<int>? durationsList;

  SessionDurationModel({this.durationsList});

  factory SessionDurationModel.fromJson(Map<String, dynamic> json) {
    List<dynamic> durationsJson = json['durations'] ?? [];
    List<int> durations = durationsJson.map((e) => e as int).toList();
    return SessionDurationModel(durationsList: durations);
  }

  Map<String, dynamic> toJson() {
    return {
      'durations': durationsList,
    };
  }
}
