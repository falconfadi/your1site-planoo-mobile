import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/all_activities_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AllActivitiesParams extends BaseParams {

  AllActivitiesParams();
}

class AllActivitiesUseCase extends UseCase<AllActivitiesModel, AllActivitiesParams> {
  final HomeRepository repository;

  AllActivitiesUseCase(this.repository);

  @override
  Future<Result<AllActivitiesModel>> call({required AllActivitiesParams params}) {
    return repository.getAllActivities(params: params);
  }
}
