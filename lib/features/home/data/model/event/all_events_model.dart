import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/event/event_details_model.dart';

class AllEventsResponse extends ApiResponse<AllEventsModel> {
  AllEventsResponse({required super.errors, required super.message, required super.data});

  factory AllEventsResponse.fromJson(Map<String, dynamic> json) {
    return AllEventsResponse(
      errors: json["payload"]["errors"] != null
          ? AllEventsModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AllEventsModel.fromJson(json["payload"]),
    );
  }
}

class AllEventsModel extends BaseModel {

  List<EventDetailsModel>? eventsList;

  AllEventsModel({this.eventsList});

  AllEventsModel.fromJson(Map<String, dynamic> json) {
    if (json['events'] != null) {
      eventsList = <EventDetailsModel>[];
      json['events'].forEach((v) {
        eventsList!.add(EventDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (eventsList != null) {
      data['events'] = eventsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

