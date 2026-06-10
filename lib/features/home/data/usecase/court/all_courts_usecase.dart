import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/court/all_courts_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AllCourtsParams extends BaseParams {

  AllCourtsParams();
}

class AllCourtsUseCase extends UseCase<AllCourtsModel, AllCourtsParams> {
  final HomeRepository repository;

  AllCourtsUseCase(this.repository);

  @override
  Future<Result<AllCourtsModel>> call({required AllCourtsParams params}) {
    return repository.getAllCourts(params: params);
  }
}
