import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteFacilityParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final List<int> facilities;

  DeleteFacilityParams({
    required this.ownerType,
    required this.ownerId,
    required this.facilities,
  });

  Map<String, dynamic> toJson() {
    return {
      'tags': facilities,
    };
  }
}

class DeleteFacilityUseCase extends UseCase<bool, DeleteFacilityParams> {
  final HomeRepository repository;

  DeleteFacilityUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteFacilityParams params}) {
    return repository.deleteFacility(params: params);
  }
}
