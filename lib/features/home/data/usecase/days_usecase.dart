import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/days_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class DaysParams extends BaseParams {

  DaysParams();
}

class DaysUseCase extends UseCase<DaysModel, DaysParams> {
  final HomeRepository repository;

  DaysUseCase(this.repository);

  @override
  Future<Result<DaysModel>> call({required DaysParams params}) {
    return repository.getDays(params: params);
  }
}
