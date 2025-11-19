import 'package:centro_partner/features/notification/data/notification_repository/notification_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class ClearAllNotificationsParams extends BaseParams {

  ClearAllNotificationsParams();

}

class ClearAllNotificationsUseCase extends UseCase<bool, ClearAllNotificationsParams> {
  final NotificationRepository repository;

  ClearAllNotificationsUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ClearAllNotificationsParams params}) {
    return repository.clearAllNotifications(params: params);
  }
}
