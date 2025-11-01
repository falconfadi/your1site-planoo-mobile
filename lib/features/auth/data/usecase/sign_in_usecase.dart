import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/sign_in_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class SignInParams extends BaseParams {

final String? phone;
final String? password;

SignInParams({this.phone, this.password});

  Map<String, String?> toJson() {
    return {
      "phone": phone,
      "password": password,
    };
  }
}

class SignInUseCase extends UseCase<SignInModel, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<Result<SignInModel>> call({required SignInParams params}) {
    return repository.login(params: params);
  }
}