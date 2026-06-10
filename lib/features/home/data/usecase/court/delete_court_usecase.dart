import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteCourtParams extends BaseParams {

  final int courtId;

  DeleteCourtParams({
    required this.courtId,
  });

  Map<String, String?> toJson() {
    return {
      'activity_id': courtId.toString(),
    };
  }
}

class DeleteCourtUseCase extends UseCase<bool, DeleteCourtParams> {
  final HomeRepository repository;

  DeleteCourtUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteCourtParams params}) {
    return repository.deleteCourt(params: params);
  }
}
