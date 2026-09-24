import 'package:centro_partner/core/utils/project_utils/phone_utils.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class VerifyCodeParams extends BaseParams {

  final String? phone,countryCode,code;

  VerifyCodeParams({this.phone,this.countryCode,this.code});

  Map<String, String?> toJson() {
    return {
      "phone": toNationalPhoneNumber(phone),
      "country_code": countryCode,
      "code": code,
    };
  }
}

class VerifyCodeUseCase extends UseCase<bool, VerifyCodeParams> {
  final AuthRepository repository;

  VerifyCodeUseCase(this.repository);

  @override
  Future<Result<bool>> call({required VerifyCodeParams params}) {
    return repository.verify(params: params);
  }
}