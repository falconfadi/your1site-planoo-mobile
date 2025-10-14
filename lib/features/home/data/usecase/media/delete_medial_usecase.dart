import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteMediaParams extends BaseParams {

  final String ownerType;
  final int ownerId;
  final int mediaId;

  DeleteMediaParams({
    required this.ownerType,
    required this.ownerId,
    required this.mediaId,
  });

  Map<String, dynamic> toJson() {
    return {
      'media_id': mediaId,
    };
  }
}

class DeleteMediaUseCase extends UseCase<bool, DeleteMediaParams> {
  final HomeRepository repository;

  DeleteMediaUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteMediaParams params}) {
    return repository.deleteMedia(params: params);
  }
}
