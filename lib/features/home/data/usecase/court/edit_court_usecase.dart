import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/court/court_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EditCourtParams extends BaseParams {

  final int? courtId;
  final String name;
  final int categoryId;
  final String description;
  final int sessionDuration;
  final String price;

  EditCourtParams({
    required this.courtId,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.sessionDuration,
    required this.price,
  });

  Map<String, String?> toJson() {
    return {
      'activity_id': courtId.toString(),
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'session_duration': sessionDuration.toString(),
      'price': price,
    };
  }
}

class EditCourtUseCase extends UseCase<CourtModel, EditCourtParams> {
  final HomeRepository repository;

  EditCourtUseCase(this.repository);

  @override
  Future<Result<CourtModel>> call({required EditCourtParams params}) {
    return repository.editCourt(params: params);
  }
}
