import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/features/notification/data/model/notifications_model.dart' hide Result;
import 'package:centro_partner/features/notification/data/usecase/clear_all_notifications_usecase.dart';
import 'package:centro_partner/features/notification/data/usecase/delete_notification_usecase.dart';
import 'package:centro_partner/features/notification/data/usecase/notifications_usecase.dart';
import 'package:centro_partner/features/notification/data/usecase/view_notification_usecase.dart';
import '../../../../core/constants/end_point.dart';
import '../../../../core/data_source/remote_data_source.dart';
import '../../../../core/http/http_method.dart';
import '../../../../core/results/result.dart';

class NotificationRepository extends CoreRepository {

  Future<Result<NotificationsModel>> getNotifications({required NotificationsParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: getNotificationsUrl,
        method: HttpMethod.GET,
        responseStr: 'NotificationsResponse',
        converter: (json) => NotificationsResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> viewNotification({required ViewNotificationParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
        withAuthentication: true,
        url: viewNotificationUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> deleteNotification({required DeleteNotificationParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: deleteNotificationUrl,
      data: params.toJson(),
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> clearAllNotifications({required ClearAllNotificationsParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: clearNotificationsUrl,
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

}