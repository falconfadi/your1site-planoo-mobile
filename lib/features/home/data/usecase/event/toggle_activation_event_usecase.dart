import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class ToggleActivationEventParams extends BaseParams {

  final int eventId;

  ToggleActivationEventParams({
    required this.eventId,
  });

  Map<String, String?> toJson() {
    return {
      'event_id': eventId.toString(),
    };
  }
}

class ToggleActivationEventUseCase extends UseCase<bool, ToggleActivationEventParams> {
  final HomeRepository repository;

  ToggleActivationEventUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ToggleActivationEventParams params}) {
    return repository.toggleActivationEvent(params: params);
  }
}
