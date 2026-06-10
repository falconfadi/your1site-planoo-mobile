import 'dart:io';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/course/course_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateCourseParams extends BaseParams {

  final String name;
  final int categoryId;
  final String description;
  final int courseDuration;
  final String price;
  final double longitude;
  final double latitude;
  final String startDate;
  final String fromTime;
  final String endTime;
  final List<int> tags;
  final List<String> days;
  final List<File>? files;
  final String capacity;
  final String cancellationFee;

  CreateCourseParams({
    required this.name,
    required this.categoryId,
    required this.description,
    required this.courseDuration,
    required this.price,
    required this.longitude,
    required this.latitude,
    required this.startDate,
    required this.fromTime,
    required this.endTime,
    required this.tags,
    required this.days,
    this.files,
    required this.capacity,
    required this.cancellationFee,
  });

  Map<String, dynamic> toFormDataMap() {
    Map<String, dynamic> data = {
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'course_duration': courseDuration.toString(),
      'price': price,
      'type': 'image',
      'long': longitude.toString(),
      'lat': latitude.toString(),
      'start_date': startDate,
      'capacity': capacity,
      'cancellation_fee': cancellationFee,
    };

    for (int i = 0; i < days.length; i++) {
      data['days[$i][day]'] = days[i];
      data['days[$i][start]'] = fromTime;
      data['days[$i][end]'] = endTime;
    }

    data['tags[]'] = tags.map((t) => t.toString()).toList();

    return data;
  }
}

class CreateCourseUseCase extends UseCase<CourseModel, CreateCourseParams> {
  final HomeRepository repository;

  CreateCourseUseCase(this.repository);

  @override
  Future<Result<CourseModel>> call({required CreateCourseParams params}) {
    return repository.createCourse(params: params);
  }
}
