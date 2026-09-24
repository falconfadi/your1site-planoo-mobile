import 'package:centro_partner/core/utils/project_utils/phone_utils.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class RegisterParams extends BaseParams {

  final String? name,phone,countryCode,email,password,confirmationPassword,accountType,description,firebaseToken;

  RegisterParams({
    this.name,
    this.phone,
    this.countryCode,
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
      "phone": toNationalPhoneNumber(phone),
      "country_code": countryCode,
      "email": email,
      "password": password,
      "password_confirmation": confirmationPassword,
      "account_type": accountType,
      "description": description,
      "firebase_token": firebaseToken
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
