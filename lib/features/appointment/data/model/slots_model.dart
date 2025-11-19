import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/appointment/data/model/slot_details_model.dart';

class SlotsResponse extends ApiResponse<SlotsModel> {
  SlotsResponse({required super.errors, required super.message, required super.data});

  factory SlotsResponse.fromJson(Map<String, dynamic> json) {
    return SlotsResponse(
      errors: json["payload"]["errors"] != null
          ? SlotsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: SlotsModel.fromJson(json["payload"]),
    );
  }
}


class SlotsModel extends BaseModel {

  SlotModel? slot;

  SlotsModel({this.slot});

  SlotsModel.fromJson(Map<String, dynamic> json) {
    slot = json['slots'] != null ? SlotModel.fromJson(json['slots']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (slot != null) {
      data['slots'] = slot!.toJson();
    }
    return data;
  }
}

class SlotModel extends BaseModel {

  int? code;
  String? day;
  String? date;
  List<SlotDetailsModel>? slots;

  SlotModel({
    this.code,
    this.day,
    this.date,
    this.slots
  });

  SlotModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    day = json['day'];
    date = json['date'];
    if (json['slots'] != null) {
      slots = <SlotDetailsModel>[];
      json['slots'].forEach((v) {
        slots!.add(SlotDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['day'] = day;
    data['date'] = date;
    if (slots != null) {
      data['slots'] = slots!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

