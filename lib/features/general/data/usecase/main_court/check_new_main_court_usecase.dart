import 'package:centro_partner/core/params/base_params.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/core/usecase/usecase.dart';
import 'package:centro_partner/features/general/data/general_repository/general_repository.dart';
import 'package:centro_partner/features/general/data/model/main_court/check_new_main_court_model.dart';

class CheckNewMainCourtParams extends BaseParams {

  CheckNewMainCourtParams();
}

class CheckNewMainCourtUseCase extends UseCase<CheckNewMainCourtModel, CheckNewMainCourtParams> {
  final GeneralRepository repository;

  CheckNewMainCourtUseCase(this.repository);

  @override
  Future<Result<CheckNewMainCourtModel>> call({required CheckNewMainCourtParams params}) {
    return repository.checkNewMainCourt(params: params);
  }
}
