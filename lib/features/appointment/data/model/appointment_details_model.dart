import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';


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
  String? canceledBy; // todo check later the type
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

  HolderModel({
    this.id,
    this.type,
  });

  HolderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    return data;
  }
}

class CustomerModel {
  int? id;
  String? name;
  String? phone;
  int? status;

  CustomerModel({
    this.id,
    this.name,
    this.phone,
    this.status,
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['status'] = status;
    return data;
  }
}