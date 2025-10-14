import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateFacilityParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final List<int> facilities;

  CreateFacilityParams({
    required this.ownerType,
    required this.ownerId,
    required this.facilities
  });

  Map<String, dynamic> toJson() {
    return {
      'tags': facilities,
    };
  }
}

class CreateFacilityUseCase extends UseCase<bool, CreateFacilityParams> {
  final HomeRepository repository;

  CreateFacilityUseCase(this.repository);

  @override
  Future<Result<bool>> call({required CreateFacilityParams params}) {
    return repository.createFacility(params: params);
  }
}
