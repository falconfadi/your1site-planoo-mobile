
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
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['created_at'] = this.createdAt;
    data['is_verified'] = this.isVerified;
    data['is_filled'] = this.isFilled;
    return data;
  }
}