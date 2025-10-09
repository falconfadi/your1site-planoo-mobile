import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';

class UserModel {

  int? id;
  String? name;
  String? email;
  String? phone;
  String? accountType;
  String? description;
  String? isVerified;
  bool? isNotifiable;
  int? isActive;
  String? createdAt;
  ImageModel? profileImage;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.accountType,
    this.description,
    this.isVerified,
    this.isNotifiable,
    this.isActive,
    this.createdAt,
    this.profileImage
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    accountType = json['account_type'];
    description = json['description'];
    isVerified = json['is_verified'];
    isNotifiable = json['is_notifiable'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    profileImage = json['profile_image'] != null ? ImageModel.fromJson(json['profile_image']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['account_type'] = accountType;
    data['description'] = description;
    data['is_verified'] = isVerified;
    data['is_notifiable'] = isNotifiable;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    if (profileImage != null) {
      data['profile_image'] = profileImage!.toJson();
    }
    return data;
  }
}