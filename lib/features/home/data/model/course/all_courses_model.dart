import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/course/course_details_model.dart';

class AllCoursesResponse extends ApiResponse<AllCoursesModel> {
  AllCoursesResponse({required super.errors, required super.message, required super.data});

  factory AllCoursesResponse.fromJson(Map<String, dynamic> json) {
    return AllCoursesResponse(
      errors: json["payload"]["errors"] != null
          ? AllCoursesModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: AllCoursesModel.fromJson(json["payload"]),
    );
  }
}

class AllCoursesModel extends BaseModel {

  List<CourseDetailsModel>? coursesList;

  AllCoursesModel({this.coursesList});

  AllCoursesModel.fromJson(Map<String, dynamic> json) {
    if (json['courses'] != null) {
      coursesList = <CourseDetailsModel>[];
      json['courses'].forEach((v) {
        coursesList!.add(CourseDetailsModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (coursesList != null) {
      data['courses'] = coursesList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

