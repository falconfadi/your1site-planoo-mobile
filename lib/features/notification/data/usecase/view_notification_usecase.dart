import 'package:centro_partner/features/notification/data/notification_repository/notification_repository.dart';
import '../../../../core/params/base_params.dart';
import '../../../../core/results/result.dart';
import '../../../../core/usecase/usecase.dart';

class ViewNotificationParams extends BaseParams {

  List notifications; /// list of notification ids

  ViewNotificationParams({required this.notifications});

  Map<String, List> toJson() {
    return {
      "notifications": notifications,
    };
  }

}

class ViewNotificationUseCase extends UseCase<bool, ViewNotificationParams> {
  final NotificationRepository repository;

  ViewNotificationUseCase(this.repository);

  @override
  Future<Result<bool>> call({required ViewNotificationParams params}) {
    return repository.viewNotification(params: params);
  }
}
