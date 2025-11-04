import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteEventParams extends BaseParams {

  final int eventId;

  DeleteEventParams({
    required this.eventId,
  });

  Map<String, String?> toJson() {
    return {
      'event_id': eventId.toString(),
    };
  }
}

class DeleteEventUseCase extends UseCase<bool, DeleteEventParams> {
  final HomeRepository repository;

  DeleteEventUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteEventParams params}) {
    return repository.deleteEvent(params: params);
  }
}
