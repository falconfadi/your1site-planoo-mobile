import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class RegisterParams extends BaseParams {

  final String? phone,email,password, confirmationPassword,type,firebaseToken;

  RegisterParams({
    this.phone,
    this.email,
    this.password,
    this.confirmationPassword,
    this.type,
    this.firebaseToken,
  });

  toJson() {
    return {
      "phone": phone,
      "email": email,
      "password": password,
      "password_confirmation": confirmationPassword,
      "type": type,
      "fb_token": firebaseToken
    };
    }
  }


class RegisterUseCase extends UseCase<bool, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Result<bool>> call({required RegisterParams params}) {
    return repository.register(params: params);
  }
}
