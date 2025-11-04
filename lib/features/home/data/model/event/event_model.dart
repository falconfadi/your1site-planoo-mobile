import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/event/event_details_model.dart';

class EventResponse extends ApiResponse<EventModel> {
  EventResponse({required super.errors, required super.message, required super.data});

  factory EventResponse.fromJson(Map<String, dynamic> json) {
    return EventResponse(
      errors: json["payload"]["errors"] != null
          ? EventModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: EventModel.fromJson(json["payload"]),
    );
  }
}

class EventModel extends BaseModel {

  EventDetailsModel? event;

  EventModel({this.event});

  EventModel.fromJson(Map<String, dynamic> json) {
    event = json['event'] != null ? EventDetailsModel.fromJson(json['event']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (event != null) {
      data['event'] = event!.toJson();
    }
    return data;
  }
}

