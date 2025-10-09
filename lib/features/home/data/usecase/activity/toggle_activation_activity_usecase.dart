import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class ToggleActivationActivityParams extends BaseParams {

  final int activityId;

  ToggleActivationActivityParams({
    required this.activityId,
  });

  Map<String, String?> toJson() {
    return {
      'activity_id': activityId.toString(),
    };
  }
}

class ToggleActivationActivityUseCase extends UseCase<bool, ToggleActivationActivityParams> {
  final HomeRepository repository;

  ToggleActivationActivityUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ToggleActivationActivityParams params}) {
    return repository.toggleActivationActivity(params: params);
  }
}
