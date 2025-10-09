import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/workday/all_workdays_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AllWorkdaysParams extends BaseParams {

  final String ownerType;
  final int ownerId;

  AllWorkdaysParams({
    required this.ownerType,
    required this.ownerId
});
}

class AllWorkdaysUseCase extends UseCase<AllWorkdaysModel, AllWorkdaysParams> {
  final HomeRepository repository;

  AllWorkdaysUseCase(this.repository);

  @override
  Future<Result<AllWorkdaysModel>> call({required AllWorkdaysParams params}) {
    return repository.getAllWorkdays(params: params);
  }
}
