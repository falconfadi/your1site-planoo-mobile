import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class ToggleActivationCourtParams extends BaseParams {

  final int courtId;

  ToggleActivationCourtParams({
    required this.courtId,
  });

  Map<String, String?> toJson() {
    return {
      'activity_id': courtId.toString(),
    };
  }
}

class ToggleActivationCourtUseCase extends UseCase<bool, ToggleActivationCourtParams> {
  final HomeRepository repository;

  ToggleActivationCourtUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ToggleActivationCourtParams params}) {
    return repository.toggleActivationCourt(params: params);
  }
}
