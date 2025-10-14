import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EditLocationParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final int locationId;
  final double lat;
  final double long;

  EditLocationParams({
    required this.ownerType,
    required this.ownerId,
    required this.locationId,
    required this.lat,
    required this.long,
  });

  Map<String, dynamic> toJson() {
    return {
      'location_id': locationId,
      'lat': lat,
      'long': long,
    };
  }
}

class EditLocationUseCase extends UseCase<bool, EditLocationParams> {
  final HomeRepository repository;

  EditLocationUseCase(this.repository);

  @override
  Future<Result<bool>> call({required EditLocationParams params}) {
    return repository.editLocation(params: params);
  }
}
