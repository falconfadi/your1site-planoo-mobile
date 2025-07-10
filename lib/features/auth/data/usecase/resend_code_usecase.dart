import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class ResendCodeParams extends BaseParams {

  final String? phone;

  ResendCodeParams({this.phone});

  toJson(){
    return {
      "phone": phone
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