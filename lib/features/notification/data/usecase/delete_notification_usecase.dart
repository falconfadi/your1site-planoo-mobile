import 'package:centro_partner/features/notification/data/notification_repository/notification_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class DeleteNotificationParams extends BaseParams {

  int notificationId;

  DeleteNotificationParams({required this.notificationId});

  Map<String, int> toJson() {
    return {
      "notification_id": notificationId,
    };
  }

}

class DeleteNotificationUseCase extends UseCase<bool, DeleteNotificationParams> {
  final NotificationRepository repository;

  DeleteNotificationUseCase(this.repository);

  @override
  Future<Result<bool>> call({required DeleteNotificationParams params}) {
    return repository.deleteNotification(params: params);
  }
}
