import 'package:centro_partner/features/general/data/general_repository/general_repository.dart';
import 'package:centro_partner/features/general/data/model/main_court/main_court_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class CreateMainCourtParams extends BaseParams {

  final String name;
  final String description;

  CreateMainCourtParams({
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
    };
  }
}

class CreateMainCourtUseCase extends UseCase<MainCourtModel, CreateMainCourtParams> {
  final GeneralRepository repository;

  CreateMainCourtUseCase(this.repository);

  @override
  Future<Result<MainCourtModel>> call({required CreateMainCourtParams params}) {
    return repository.createMainCourt(params: params);
  }
}
