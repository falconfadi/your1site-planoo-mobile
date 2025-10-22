import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/course/course_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EditCourseParams extends BaseParams {

  final int courseId;
  final String name;
  final int categoryId;
  final String description;
  final int sessionDuration;
  final int courseDuration;
  final String price;
  final String capacity;
  final String cancellationFee;

  EditCourseParams({
    required this.courseId,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.sessionDuration,
    required this.courseDuration,
    required this.price,
    required this.capacity,
    required this.cancellationFee,
  });

  Map<String, String?> toJson() {
    return {
      'course_id': courseId.toString(),
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'session_duration': sessionDuration.toString(),
      'course_duration': courseDuration.toString(),
      'price': price,
      'capacity': capacity,
      'cancellation_fee': cancellationFee,
    };
  }
}

class EditCourseUseCase extends UseCase<CourseModel, EditCourseParams> {
  final HomeRepository repository;

  EditCourseUseCase(this.repository);

  @override
  Future<Result<CourseModel>> call({required EditCourseParams params}) {
    return repository.editCourse(params: params);
  }
}
