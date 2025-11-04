import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/event/all_events_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AllEventsParams extends BaseParams {

  AllEventsParams();
}

class AllEventsUseCase extends UseCase<AllEventsModel, AllEventsParams> {
  final HomeRepository repository;

  AllEventsUseCase(this.repository);

  @override
  Future<Result<AllEventsModel>> call({required AllEventsParams params}) {
    return repository.getAllEvents(params: params);
  }
}
