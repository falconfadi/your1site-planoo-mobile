import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteWorkdayParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final int dayId;

  DeleteWorkdayParams({
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

class DeleteWorkdayUseCase extends UseCase<bool, DeleteWorkdayParams> {
  final HomeRepository repository;

  DeleteWorkdayUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteWorkdayParams params}) {
    return repository.deleteWorkday(params: params);
  }
}
