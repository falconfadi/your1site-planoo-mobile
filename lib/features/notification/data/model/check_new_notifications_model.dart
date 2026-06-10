import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class CheckNewNotificationsResponse extends ApiResponse<CheckNewNotificationsModel> {

  CheckNewNotificationsResponse({required super.errors, required super.message, required super.data});

  factory CheckNewNotificationsResponse.fromJson(Map<String, dynamic> json) {
    return CheckNewNotificationsResponse(
      errors: json["payload"]["errors"] != null
          ? CheckNewNotificationsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: CheckNewNotificationsModel.fromJson(json["payload"]),
    );
  }
}

class CheckNewNotificationsModel extends BaseModel {

  bool? newNotifications;

  CheckNewNotificationsModel({this.newNotifications});

  CheckNewNotificationsModel.fromJson(Map<String, dynamic> json) {
    newNotifications = json['new'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['new'] = this.newNotifications;
    return data;
  }
}
