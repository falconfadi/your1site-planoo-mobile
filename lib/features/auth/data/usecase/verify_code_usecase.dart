import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class VerifyCodeParams extends BaseParams {

  final String? phone,code;

  VerifyCodeParams({this.phone,this.code});

  toJson() {
    return {
      "phone": phone,
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