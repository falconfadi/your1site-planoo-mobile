import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class ChangePasswordParams extends BaseParams {

  final String? oldPassword;
  final String? newPassword;
  final String? confirmationPassword;

  ChangePasswordParams({
    this.oldPassword,
    this.newPassword,
    this.confirmationPassword,
  });

  Map<String, String?> toJson() {
    return {
      "old_password": oldPassword,
      "new_password": newPassword,
      "new_password_confirmation": confirmationPassword,
    };
  }
}

class ChangePasswordUseCase extends UseCase<bool, ChangePasswordParams> {
  final AuthRepository repository;

  ChangePasswordUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ChangePasswordParams params}) {
    return repository.changePassword(params: params);
  }
}
