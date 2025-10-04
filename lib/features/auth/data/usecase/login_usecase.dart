import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/login_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';


class LoginParams extends BaseParams {

final String? phone;
final String? password;

  LoginParams({this.phone, this.password});

  Map<String, String?> toJson() {
    return {
      "phone": phone,
      "password": password,
    };
  }
}

class LoginUseCase extends UseCase<LoginModel, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Result<LoginModel>> call({required LoginParams params}) {
    return repository.login(params: params);
  }
}