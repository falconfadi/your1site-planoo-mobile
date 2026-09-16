import 'package:centro_partner/features/general/data/general_repository/general_repository.dart';
import 'package:centro_partner/features/general/data/model/main_court/all_main_courts_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AllMainCourtsParams extends BaseParams {

  AllMainCourtsParams();
}

class AllMainCourtsUseCase extends UseCase<AllMainCourtsModel, AllMainCourtsParams> {
  final GeneralRepository repository;

  AllMainCourtsUseCase(this.repository);

  @override
  Future<Result<AllMainCourtsModel>> call({required AllMainCourtsParams params}) {
    return repository.getAllMainCourts(params: params);
  }
}
