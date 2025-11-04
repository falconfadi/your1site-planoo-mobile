import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/event/event_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EventDetailsParams extends BaseParams {

  final int eventId;

  EventDetailsParams({required this.eventId});
}

class EventDetailsUseCase extends UseCase<EventModel, EventDetailsParams> {
  final HomeRepository repository;

  EventDetailsUseCase(this.repository);

  @override
  Future<Result<EventModel>> call({required EventDetailsParams params}) {
    return repository.getEventDetails(params: params);
  }
}
