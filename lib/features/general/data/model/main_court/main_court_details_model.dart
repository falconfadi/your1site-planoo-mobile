import 'package:centro_partner/features/home/data/model/course/course_details_model.dart';
import 'package:centro_partner/features/home/data/model/court/court_details_model.dart';
import 'package:centro_partner/features/home/data/model/event/event_details_model.dart';

class MainCourtDetailsModel {
  String? id;
  String? name;
  String? description;
  List<CourtDetailsModel>? courtsList;
  List<CourseDetailsModel>? coursesList;
  List<EventDetailsModel>? eventsList;

  MainCourtDetailsModel({
    this.id,
    this.name,
    this.description,
    this.courtsList,
    this.coursesList,
    this.eventsList
  });

  MainCourtDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    if (json['activities'] != null) {
      courtsList = <CourtDetailsModel>[];
      json['activities'].forEach((v) {
        courtsList!.add(CourtDetailsModel.fromJson(v));
      });
    }
    if (json['courses'] != null) {
      coursesList = <CourseDetailsModel>[];
      json['courses'].forEach((v) {
        coursesList!.add(CourseDetailsModel.fromJson(v));
      });
    }
    if (json['events'] != null) {
      eventsList = <EventDetailsModel>[];
      json['events'].forEach((v) {
        eventsList!.add(EventDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    if (courtsList != null) {
      data['activities'] = courtsList!.map((v) => v.toJson()).toList();
    }
    if (coursesList != null) {
      data['courses'] = coursesList!.map((v) => v.toJson()).toList();
    }
    if (eventsList != null) {
      data['events'] = eventsList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
