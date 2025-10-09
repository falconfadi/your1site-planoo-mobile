import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class ActivityDetailsParams extends BaseParams {

  final int activityId;


  ActivityDetailsParams({required this.activityId});
}

class ActivityDetailsUseCase extends UseCase<ActivityModel, ActivityDetailsParams> {
  final HomeRepository repository;

  ActivityDetailsUseCase(this.repository);

  @override
  Future<Result<ActivityModel>> call({required ActivityDetailsParams params}) {
    return repository.getActivityDetails(params: params);
  }
}
