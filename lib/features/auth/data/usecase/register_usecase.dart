import 'package:centro_partner/features/auth/data/model/register_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class RegisterParams extends BaseParams {

  final String? name,phone,email,password,confirmationPassword,accountType,description,firebaseToken;

  RegisterParams({
    this.name,
    this.phone,
    this.email,
    this.password,
    this.confirmationPassword,
    this.accountType,
    this.description,
    this.firebaseToken,
  });

  Map<String, String?> toJson() {
    return {
      "name": name,
      "phone": phone,
      "email": email,
      "password": password,
      "password_confirmation": confirmationPassword,
      "account_type": accountType,
      "description": description,
      "fb_token": firebaseToken
    };
  }
}


class RegisterUseCase extends UseCase<RegisterModel, RegisterParams> {
  final AuthRepository repository;

  RegisterUseCase(this.repository);

  @override
  Future<Result<RegisterModel>> call({required RegisterParams params}) {
    return repository.register(params: params);
  }
}
