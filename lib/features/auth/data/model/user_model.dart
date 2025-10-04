
class UserModel {

  int? id;
  String? email;
  String? phone;
  String? role;
  String? createdAt;
  String? isVerified;
  int? isFilled;

  UserModel({
    this.id,
    this.email,
    this.phone,
    this.role,
    this.createdAt,
    this.isVerified,
    this.isFilled,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    createdAt = json['created_at'];
    isVerified = json['is_verified'];
    isFilled = json['is_filled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    data['role'] = role;
    data['created_at'] = createdAt;
    data['is_verified'] = isVerified;
    data['is_filled'] = isFilled;
    return data;
  }
}