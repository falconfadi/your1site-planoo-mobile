
class CustomerModel {
  int? id;
  String? name;
  String? phone;
  int? status;
  DetailsModel? details;

  CustomerModel({
    this.id,
    this.name,
    this.phone,
    this.status,
    this.details
  });

  CustomerModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    status = json['status'];
    details = json['details'] != null ? DetailsModel.fromJson(json['details']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['status'] = status;
    if (details != null) {
      data['details'] = details!.toJson();
    }
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