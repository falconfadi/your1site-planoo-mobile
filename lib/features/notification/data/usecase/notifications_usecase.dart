import 'package:centro_partner/features/notification/data/model/notifications_model.dart' hide Result;
import 'package:centro_partner/features/notification/data/notification_repository/notification_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class NotificationsParams extends BaseParams {

  NotificationsParams();
}

class NotificationsUseCase extends UseCase<NotificationsModel, NotificationsParams> {
  final NotificationRepository repository;

  NotificationsUseCase(this.repository);

  @override
  Future<Result<NotificationsModel>> call({required NotificationsParams params}) {
    return repository.getNotifications(params: params);
  }
}
