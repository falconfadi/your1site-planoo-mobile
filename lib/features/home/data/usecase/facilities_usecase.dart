import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/facility_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class FacilitiesParams extends BaseParams {

  FacilitiesParams();
}

class FacilitiesUseCase extends UseCase<FacilityModel, FacilitiesParams> {
  final HomeRepository repository;

  FacilitiesUseCase(this.repository);

  @override
  Future<Result<FacilityModel>> call({required FacilitiesParams params}) {
    return repository.getFacilities(params: params);
  }
}
