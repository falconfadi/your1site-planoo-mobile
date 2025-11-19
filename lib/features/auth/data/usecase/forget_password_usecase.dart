import 'package:centro_partner/core/results/result.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/usecase/usecase.dart';
import '../auth_repository/auth_repository.dart';

class ForgetPasswordParams extends BaseParams {

  final String? phone,firebaseToken;

  ForgetPasswordParams({this.phone,this.firebaseToken});

  Map<String, String?> toJson(){
    return {
      "phone": phone,
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

