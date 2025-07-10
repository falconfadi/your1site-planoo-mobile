import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class LogoutParams extends BaseParams {

  LogoutParams();

}

class LogoutUseCase extends UseCase<bool, LogoutParams> {
  final AuthRepository repository;

  LogoutUseCase(this.repository);

  @override
  Future<Result<bool>> call({required LogoutParams params}) {
    return repository.logout(params: params);
  }
}