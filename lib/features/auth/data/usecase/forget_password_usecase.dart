import 'package:centro_partner/core/utils/project_utils/phone_utils.dart';
import 'package:centro_partner/core/results/result.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class ForgetPasswordParams extends BaseParams {

  final String? phone,countryCode,firebaseToken;

  ForgetPasswordParams({this.phone,this.countryCode,this.firebaseToken});

  Map<String, String?> toJson(){
    return {
      "phone": toNationalPhoneNumber(phone),
      "country_code": countryCode,
      "firebase_token": firebaseToken
    };
  }
}

class ForgetPasswordUseCase extends UseCase<bool, ForgetPasswordParams> {
  final AuthRepository repository;

  ForgetPasswordUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ForgetPasswordParams params}) {
    return repository.forgetPassword(params: params);
  }
}

