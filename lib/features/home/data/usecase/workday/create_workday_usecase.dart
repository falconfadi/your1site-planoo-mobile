import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/workday/workday_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateWorkdayParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final String day;
  final String start;
  final String end;

  CreateWorkdayParams({
    required this.ownerType,
    required this.ownerId,
    required this.day,
    required this.start,
    required this.end,
  });

  Map<String, String?> toJson() {
    return {
      'day': day,
      'start': start,
      'end': end,
    };
  }
}

class CreateWorkdayUseCase extends UseCase<WorkdayModel, CreateWorkdayParams> {
  final HomeRepository repository;

  CreateWorkdayUseCase(this.repository);

  @override
  Future<Result<WorkdayModel>> call({required CreateWorkdayParams params}) {
    return repository.createWorkday(params: params);
  }
}
