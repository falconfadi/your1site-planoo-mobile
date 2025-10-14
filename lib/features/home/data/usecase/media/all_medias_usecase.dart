import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/location/all_medias_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class AllMediasParams extends BaseParams {

  final String ownerType;
  final int ownerId;

  AllMediasParams({
    required this.ownerType,
    required this.ownerId
});
}

class AllMediasUseCase extends UseCase<AllMediasModel, AllMediasParams> {
  final HomeRepository repository;

  AllMediasUseCase(this.repository);

  @override
  Future<Result<AllMediasModel>> call({required AllMediasParams params}) {
    return repository.getAllMedias(params: params);
  }
}
