import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/course/course_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CourseDetailsParams extends BaseParams {

  final int courseId;


  CourseDetailsParams({required this.courseId});
}

class CourseDetailsUseCase extends UseCase<CourseModel, CourseDetailsParams> {
  final HomeRepository repository;

  CourseDetailsUseCase(this.repository);

  @override
  Future<Result<CourseModel>> call({required CourseDetailsParams params}) {
    return repository.getCourseDetails(params: params);
  }
}
