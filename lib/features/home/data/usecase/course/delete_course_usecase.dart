import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteCourseParams extends BaseParams {

  final int courseId;

  DeleteCourseParams({
    required this.courseId,
  });

  Map<String, String?> toJson() {
    return {
      'course_id': courseId.toString(),
    };
  }
}

class DeleteCourseUseCase extends UseCase<bool, DeleteCourseParams> {
  final HomeRepository repository;

  DeleteCourseUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteCourseParams params}) {
    return repository.deleteCourse(params: params);
  }
}
