import 'package:centro_partner/features/general/data/general_repository/general_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteMainCourtParams extends BaseParams {

  final String mainCourtId;

  DeleteMainCourtParams({required this.mainCourtId});

  Map<String, String?> toJson() {
    return {
      'court_id': mainCourtId,
    };
  }
}

class DeleteMainCourtUseCase extends UseCase<bool, DeleteMainCourtParams> {
  final GeneralRepository repository;

  DeleteMainCourtUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteMainCourtParams params}) {
    return repository.deleteMainCourt(params: params);
  }
}
