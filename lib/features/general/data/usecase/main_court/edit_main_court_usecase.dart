import 'package:centro_partner/features/general/data/general_repository/general_repository.dart';
import 'package:centro_partner/features/general/data/model/main_court/main_court_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EditMainCourtParams extends BaseParams {

  final String mainCourtId;
  final String name;
  final String description;

  EditMainCourtParams({
    required this.mainCourtId,
    required this.name,
    required this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'court_id': mainCourtId,
      'name': name,
      'description': description,
    };
  }
}

class EditMainCourtUseCase extends UseCase<MainCourtModel, EditMainCourtParams> {
  final GeneralRepository repository;

  EditMainCourtUseCase(this.repository);

  @override
  Future<Result<MainCourtModel>> call({required EditMainCourtParams params}) {
    return repository.editMainCourt(params: params);
  }
}
