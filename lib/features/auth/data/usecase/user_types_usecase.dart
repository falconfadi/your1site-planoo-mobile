import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/user_type_model.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class UserTypesParams extends BaseParams {

  UserTypesParams();
}

class UserTypesUseCase extends UseCase<UserTypeModel, UserTypesParams> {
  final AuthRepository repository;

  UserTypesUseCase(this.repository);

  @override
  Future<Result<UserTypeModel>> call({required UserTypesParams params}) {
    return repository.getUserTypes(params: params);
  }
}
