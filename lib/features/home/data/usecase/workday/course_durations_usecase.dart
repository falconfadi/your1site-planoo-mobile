import 'package:centro_partner/core/params/base_params.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/core/usecase/usecase.dart';
import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/course_duration_model.dart';

class CourseDurationsParams extends BaseParams {

  CourseDurationsParams();
}

class CourseDurationsUseCase extends UseCase<CourseDurationModel, CourseDurationsParams> {
  final HomeRepository repository;

  CourseDurationsUseCase(this.repository);

  @override
  Future<Result<CourseDurationModel>> call({required CourseDurationsParams params}) {
    return repository.getCourseDurations(params: params);
  }
}
