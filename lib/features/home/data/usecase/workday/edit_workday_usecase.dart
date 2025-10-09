import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EditWorkdayParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final int dayId;
  final String start;
  final String end;

  EditWorkdayParams({
    required this.ownerType,
    required this.ownerId,
    required this.dayId,
    required this.start,
    required this.end,
  });

  Map<String, String?> toJson() {
    return {
      'day_id': dayId.toString(),
      'start': start,
      'end': end,
    };
  }
}

class EditWorkdayUseCase extends UseCase<WorkdayModel, EditWorkdayParams> {
  final HomeRepository repository;

  EditWorkdayUseCase(this.repository);

  @override
  Future<Result<WorkdayModel>> call({required EditWorkdayParams params}) {
    return repository.editWorkday(params: params);
  }
}
