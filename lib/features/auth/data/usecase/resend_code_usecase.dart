import 'package:centro_partner/core/utils/project_utils/phone_utils.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class ResendCodeParams extends BaseParams {

  final String? phone,countryCode;

  ResendCodeParams({this.phone,this.countryCode});

  Map<String, String?> toJson() {
    return {
      "phone": toNationalPhoneNumber(phone),
      "country_code": countryCode
    };
  }
}

class ResendCodeUseCase extends UseCase<bool, ResendCodeParams> {
  final AuthRepository repository;

  ResendCodeUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ResendCodeParams params}) {
    return repository.resendCode(params: params);
  }
}