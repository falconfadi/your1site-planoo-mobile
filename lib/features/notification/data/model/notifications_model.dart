import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';

class NotificationsResponse extends ApiResponse<NotificationsModel> {
  NotificationsResponse({required super.errors, required super.message, required super.data});

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      errors: json["payload"]["errors"] != null
          ? NotificationsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: NotificationsModel.fromJson(json["payload"]),
    );
  }
}

class NotificationsModel extends BaseModel {

  List<NotificationInfoModel>? notificationsList;

  NotificationsModel({this.notificationsList});

  NotificationsModel.fromJson(Map<String, dynamic> json) {
    if (json['notifications'] != null) {
      notificationsList = <NotificationInfoModel>[];
      json['notifications'].forEach((v) {
        notificationsList!.add(new NotificationInfoModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.notificationsList != null) {
      data['notifications'] = this.notificationsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class NotificationInfoModel extends BaseModel {
  int? notificationId;
  String? title;
  String? body;
  String? type;
  bool? isViewed;
  Payload? payload;
  String? createdAt;

  NotificationInfoModel({
    this.notificationId,
    this.title,
    this.body,
    this.type,
    this.isViewed,
    this.payload,
    this.createdAt,
  });

  NotificationInfoModel.fromJson(Map<String, dynamic> json) {
    notificationId = json['id'];
    title = json['title'];
    body = json['body'];
    type = json['type'];
    isViewed = json['is_viewed'];
    payload = json['payload'] != null ? Payload.fromJson(json['payload']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.notificationId;
    data['title'] = this.title;
    data['body'] = this.body;
    data['type'] = this.type;
    data['is_viewed'] = this.isViewed;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}


class Payload {
  int? type;
  int? code;
  int? appointment;
  int? course;
  int? event;
  Result? result;

  Payload({
    this.type,
    this.code,
    this.appointment,
    this.course,
    this.event,
    this.result,
  });

  Payload.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    code = json['code'];
    appointment = json['appointment'];
    course = json['course'];
    event = json['event'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = this.type;
    data['code'] = this.code;
    data['appointment'] = this.appointment;
    data['course'] = this.course;
    data['event'] = this.event;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? name;

  Result({this.name});

  Result.fromJson(Map<String, dynamic> json) {
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = this.name;
    return data;
  }
}