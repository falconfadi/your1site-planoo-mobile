import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/category_model.dart';
import 'package:centro_partner/features/home/data/model/customer_model.dart';

class AppointmentDetailsResponse extends ApiResponse<AppointmentDetailsModel> {
  AppointmentDetailsResponse({required super.errors, required super.message, required super.data});

  factory AppointmentDetailsResponse.fromJson(Map<String, dynamic> json) {
    return AppointmentDetailsResponse(
      errors: json["payload"]["errors"] != null
          ? AppointmentDetailsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AppointmentDetailsModel.fromJson(json["payload"]["appointment"]),
    );
  }
}

class AppointmentDetailsModel extends BaseModel {

  int? iD;
  String? date;
  String? time;
  String? status;
  int? price;
  int? sessionDuration;
  String? canceledBy;
  String? notes;
  HolderModel? holder;
  CustomerModel? customer;

  AppointmentDetailsModel({
    this.iD,
    this.date,
    this.time,
    this.status,
    this.price,
    this.sessionDuration,
    this.canceledBy,
    this.notes,
    this.holder,
    this.customer
  });

  AppointmentDetailsModel.fromJson(Map<String, dynamic> json) {
    iD = json['id'];
    date = json['date'];
    time = json['time'];
    status = json['status'];
    price = json['price'];
    sessionDuration = json['session_duration'];
    canceledBy = json['canceled_by'];
    notes = json['notes'];
    holder = json['holder'] != null ? HolderModel.fromJson(json['holder']) : null;
    customer = json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null;

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = iD;
    data['date'] = date;
    data['time'] = time;
    data['status'] = status;
    data['price'] = price;
    data['session_duration'] = sessionDuration;
    data['canceled_by'] = canceledBy;
    data['notes'] = notes;
    if (holder != null) {
      data['holder'] = holder!.toJson();
    }
    if (customer != null) {
      data['customer'] = customer!.toJson();
    }
    return data;
  }
}

class HolderModel {
  int? id;
  String? type;
  String? name;
  CategoryInfoModel? category;
  int? rate;
  String? description;
  HolderImageModel? holderImage;
  int? price;

  HolderModel({
    this.id,
    this.type,
    this.name,
    this.category,
    this.rate,
    this.description,
    this.holderImage,
    this.price
  });

  HolderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    name = json['name'];
    category = json['category'] != null ? CategoryInfoModel.fromJson(json['category']) : null;
    rate = json['rate'];
    description = json['description'];
    holderImage = json['image'] != null ? HolderImageModel.fromJson(json['image']) : null;
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['name'] = name;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    data['rate'] = rate;
    data['description'] = description;
    if (holderImage != null) {
      data['image'] = holderImage!.toJson();
    }
    data['price'] = price;
    return data;
  }
}

class HolderImageModel {
  int? id;
  String? belongToType;
  int? belongToId;
  String? url;
  String? type;
  String? name;
  String? createdAt;
  String? updatedAt;

  HolderImageModel({
    this.id,
    this.belongToType,
    this.belongToId,
    this.url,
    this.type,
    this.name,
    this.createdAt,
    this.updatedAt,
  });

  HolderImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    belongToType = json['belongTo_type'];
    belongToId = json['belongTo_id'];
    url = json['url'];
    type = json['type'];
    name = json['name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['belongTo_type'] = belongToType;
    data['belongTo_id'] = belongToId;
    data['url'] = url;
    data['type'] = type;
    data['name'] = name;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

