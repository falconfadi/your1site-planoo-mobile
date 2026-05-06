import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class DeleteUserParams extends BaseParams {

  DeleteUserParams();
}

class DeleteUserUseCase extends UseCase<bool, DeleteUserParams> {
  final ProfileRepository repository;

  DeleteUserUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteUserParams params}) {
    return repository.deleteUser(params: params);
  }
}
