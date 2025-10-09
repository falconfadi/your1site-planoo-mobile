import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class DeleteProfileImageParams extends BaseParams {

  DeleteProfileImageParams();

}

class DeleteProfileImageUseCase extends UseCase<bool, DeleteProfileImageParams> {
  final ProfileRepository repository;

  DeleteProfileImageUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteProfileImageParams params}) {
    return repository.deleteProfileImage(params: params);
  }
}
