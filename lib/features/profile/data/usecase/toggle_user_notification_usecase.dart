import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class ToggleUserNotificationParams extends BaseParams {

  ToggleUserNotificationParams();

}

class ToggleUserNotificationUseCase extends UseCase<bool, ToggleUserNotificationParams> {
  final ProfileRepository repository;

  ToggleUserNotificationUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ToggleUserNotificationParams params}) {
    return repository.toggleUserNotification(params: params);
  }
}
