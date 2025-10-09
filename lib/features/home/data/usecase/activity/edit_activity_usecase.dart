import 'package:centro_partner/features/home/data/home_repository/home_repository.dart';
import 'package:centro_partner/features/home/data/model/activity/activity_model.dart';
import '../../../../../core/params/base_params.dart';
import '../../../../../core/results/result.dart';
import '../../../../../core/usecase/usecase.dart';

class EditActivityParams extends BaseParams {

  final int? activityId;
  final String name;
  final int categoryId;
  final String description;
  final int sessionDuration;
  final String price;

  EditActivityParams({
    required this.activityId,
    required this.name,
    required this.categoryId,
    required this.description,
    required this.sessionDuration,
    required this.price,
  });

  Map<String, String?> toJson() {
    return {
      'activity_id': activityId.toString(),
      'name': name,
      'category_id': categoryId.toString(),
      'description': description,
      'session_duration': sessionDuration.toString(),
      'price': price,
    };
  }
}

class EditActivityUseCase extends UseCase<ActivityModel, EditActivityParams> {
  final HomeRepository repository;

  EditActivityUseCase(this.repository);

  @override
  Future<Result<ActivityModel>> call({required EditActivityParams params}) {
    return repository.editActivity(params: params);
  }
}
