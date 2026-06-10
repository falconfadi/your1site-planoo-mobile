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
  final int courseDuration;
  final String price;
  final String capacity;
  final String cancellationFee;
  final String startDate;

  EditCourseParams({
    required this.courseId,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.courseDuration,
    required this.price,
    required this.capacity,
    required this.cancellationFee,
    required this.startDate,
  });

  Map<String, String?> toJson() {
    return {
      'course_id': courseId.toString(),
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'course_duration': courseDuration.toString(),
      'price': price,
      'capacity': capacity,
      'cancellation_fee': cancellationFee,
      'start_date': startDate,
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
