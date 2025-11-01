import 'package:centro_partner/features/auth/data/model/sign_in_model.dart';
import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class EditUserParams extends BaseParams {

  final String name;
  final String description;

  EditUserParams({required this.name,required this.description});

  Map<String, String?> toJson() {
    return {
      "name": name,
      "description": description,
    };
  }
}

class EditUserUseCase extends UseCase<SignInModel, EditUserParams> {
  final ProfileRepository repository;

  EditUserUseCase(this.repository);

  @override
  Future<Result<SignInModel>> call({required EditUserParams params}) {
    return repository.editUser(params: params);
  }
}