import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteActivityParams extends BaseParams {

  final int activityId;

  DeleteActivityParams({
    required this.activityId,
  });

  Map<String, String?> toJson() {
    return {
      'activity_id': activityId.toString(),
    };
  }
}

class DeleteActivityUseCase extends UseCase<bool, DeleteActivityParams> {
  final HomeRepository repository;

  DeleteActivityUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteActivityParams params}) {
    return repository.deleteActivity(params: params);
  }
}
