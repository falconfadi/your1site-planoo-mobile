import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class UpdateFirebaseTokenParams extends BaseParams {

  final String firebaseToken;

  UpdateFirebaseTokenParams({required this.firebaseToken});

  Map<String, String> toJson() {
    return {
      "firebase_token": firebaseToken,
    };
  }
}

class UpdateFirebaseTokenUseCase extends UseCase<bool, UpdateFirebaseTokenParams> {
  final AuthRepository repository;

  UpdateFirebaseTokenUseCase(this.repository);

  @override
  Future<Result<bool>> call({required UpdateFirebaseTokenParams params}) {
    return repository.updateFirebaseToken(params: params);
  }
}
