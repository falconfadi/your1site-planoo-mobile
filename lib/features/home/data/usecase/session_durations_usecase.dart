import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/session_duration_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class SessionDurationsParams extends BaseParams {

  SessionDurationsParams();
}

class SessionDurationsUseCase extends UseCase<SessionDurationModel, SessionDurationsParams> {
  final HomeRepository repository;

  SessionDurationsUseCase(this.repository);

  @override
  Future<Result<SessionDurationModel>> call({required SessionDurationsParams params}) {
    return repository.getSessionDurations(params: params);
  }
}
