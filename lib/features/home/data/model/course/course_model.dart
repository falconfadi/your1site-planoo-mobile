import 'package:centro_partner/core/data_source/model.dart';
import 'package:centro_partner/core/responses/api_response.dart';
import 'package:centro_partner/features/home/data/model/course/course_details_model.dart';

class CourseResponse extends ApiResponse<CourseModel> {
  CourseResponse({required super.errors, required super.message, required super.data});

  factory CourseResponse.fromJson(Map<String, dynamic> json) {
    return CourseResponse(
      errors: json["payload"]["errors"] != null
          ? CourseModel.fromJson(json["payload"]["errors"])
          : null,
      message: json["message"],
      data: CourseModel.fromJson(json["payload"]),
    );
  }
}

class CourseModel extends BaseModel {

  CourseDetailsModel? course;

  CourseModel({this.course});

  CourseModel.fromJson(Map<String, dynamic> json) {
    course = json['course'] != null ? CourseDetailsModel.fromJson(json['course']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (course != null) {
      data['course'] = course!.toJson();
    }
    return data;
  }
}

