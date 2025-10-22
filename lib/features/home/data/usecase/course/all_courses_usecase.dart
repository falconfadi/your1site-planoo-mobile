import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/course/all_courses_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AllCoursesParams extends BaseParams {

  AllCoursesParams();
}

class AllCoursesUseCase extends UseCase<AllCoursesModel, AllCoursesParams> {
  final HomeRepository repository;

  AllCoursesUseCase(this.repository);

  @override
  Future<Result<AllCoursesModel>> call({required AllCoursesParams params}) {
    return repository.getAllCourses(params: params);
  }
}
