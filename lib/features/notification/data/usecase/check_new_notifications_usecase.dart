import 'package:centro_partner/features/notification/data/model/check_new_notifications_model.dart';
import 'package:centro_partner/features/notification/data/notification_repository/notification_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class CheckNewNotificationsParams extends BaseParams {

  CheckNewNotificationsParams();
}

class CheckNewNotificationsUseCase extends UseCase<CheckNewNotificationsModel, CheckNewNotificationsParams> {
  final NotificationRepository repository;

  CheckNewNotificationsUseCase(this.repository);

  @override
  Future<Result<CheckNewNotificationsModel>> call({required CheckNewNotificationsParams params}) {
    return repository.checkNewNotifications(params: params);
  }
}
