import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class ToggleActivationCourseParams extends BaseParams {

  final int courseId;

  ToggleActivationCourseParams({
    required this.courseId,
  });

  Map<String, String?> toJson() {
    return {
      'course_id': courseId.toString(),
    };
  }
}

class ToggleActivationCourseUseCase extends UseCase<bool, ToggleActivationCourseParams> {
  final HomeRepository repository;

  ToggleActivationCourseUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ToggleActivationCourseParams params}) {
    return repository.toggleActivationCourse(params: params);
  }
}
