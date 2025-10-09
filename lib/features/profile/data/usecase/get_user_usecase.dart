import 'package:centro_partner/features/auth/data/model/login_model.dart';
import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class GetUserParams extends BaseParams {

  GetUserParams();
}

class GetUserUseCase extends UseCase<LoginModel, GetUserParams> {
  final ProfileRepository repository;

  GetUserUseCase(this.repository);

  @override
  Future<Result<LoginModel>> call({required GetUserParams params}) {
    return repository.getUser(params: params);
  }
}