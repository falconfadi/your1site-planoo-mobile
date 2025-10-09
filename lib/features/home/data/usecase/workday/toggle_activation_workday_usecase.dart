import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class ToggleActivationWorkdayParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final int dayId;

  ToggleActivationWorkdayParams({
    required this.ownerType,
    required this.ownerId,
    required this.dayId,
  });

  Map<String, String?> toJson() {
    return {
      'day_id': dayId.toString(),
    };
  }
}

class ToggleActivationWorkdayUseCase extends UseCase<bool, ToggleActivationWorkdayParams> {
  final HomeRepository repository;

  ToggleActivationWorkdayUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ToggleActivationWorkdayParams params}) {
    return repository.toggleActivationWorkday(params: params);
  }
}
