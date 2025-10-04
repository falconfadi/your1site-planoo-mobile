import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class ResetPasswordParams extends BaseParams {

  final String? phone;
  final String? password;
  final String? confirmationPassword;

  ResetPasswordParams({
    this.phone,
    this.password,
    this.confirmationPassword,
  });

  Map<String, String?> toJson() {
    return {
      "phone": phone,
      "password": password,
      "password_confirmation": confirmationPassword,
    };
  }
}

class ResetPasswordUseCase extends UseCase<bool, ResetPasswordParams> {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ResetPasswordParams params}) {
    return repository.resetPassword(params: params);
  }
}
