import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';

class CustomerModel {
  int? id;
  String? name;
  int? status;
  String? isVerified;
  bool? isNotifiable;
  int? isActive;
  ImageModel? profileImage;
  int? remainingSessions;
  int? isComplete;
  String? attendedAt;

  CustomerModel({
    this.id,
    this.name,
    this.status,
    this.isVerified,
    this.isNotifiable,
    this.isActive,
    this.profileImage,
    this.remainingSessions,
    this.isComplete,
    this.attendedAt,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    status = json['status'];
    isVerified = json['is_verified'];
    isNotifiable = json['is_notifiable'];
    isActive = json['is_active'];
    profileImage = json['profile_image'] != null ? ImageModel.fromJson(json['profile_image']) : null;
    remainingSessions = json['remaining_sessions'];
    isComplete = json['is_complete'];
    attendedAt = json['attended_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['status'] = status;
    data['is_verified'] = isVerified;
    data['is_notifiable'] = isNotifiable;
    data['is_active'] = isActive;
    if (profileImage != null) {
      data['profile_image'] = profileImage!.toJson();
    }
    data['remaining_sessions'] = remainingSessions;
    data['is_complete'] = isComplete;
    data['attended_at'] = attendedAt;
    return data;
  }
}

class DetailsModel {
  int? eventId;
  int? customerId;

  DetailsModel({
    this.eventId,
    this.customerId,
  });

  DetailsModel.fromJson(Map<String, dynamic> json) {
    eventId = json['event_id'];
    customerId = json['customer_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['event_id'] = eventId;
    data['customer_id'] = customerId;
    return data;
  }
}