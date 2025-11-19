import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class ResetPasswordParams extends BaseParams {

  final String? phone,password,confirmationPassword,code,firebaseToken;

  ResetPasswordParams({
    this.phone,
    this.password,
    this.confirmationPassword,
    this.code,
    this.firebaseToken
  });

  Map<String, String?> toJson() {
    return {
      "phone": phone,
      "password": password,
      "password_confirmation": confirmationPassword,
      "code": code,
      "firebase_token": firebaseToken
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
