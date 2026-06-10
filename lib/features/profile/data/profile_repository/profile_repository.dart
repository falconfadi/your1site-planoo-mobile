import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/features/auth/data/model/sign_in_model.dart';
import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';
import 'package:centro_partner/features/profile/data/usecase/delete_profile_image_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/delete_user_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/edit_user_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/get_user_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/toggle_user_notification_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/upload_profile_image_usecase.dart';
import '../../../../core/constants/end_point.dart';
import '../../../../core/data_source/remote_data_source.dart';
import '../../../../core/http/http_method.dart';
import '../../../../core/results/result.dart';

class ProfileRepository extends CoreRepository {

  Future<Result<SignInModel>> getUser({required GetUserParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: getUserUrl,
        method: HttpMethod.GET,
        responseStr: 'LoginResponse',
        converter: (json) => SignInResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<ProfileImageModel>> uploadProfileImage({required UploadProfileImageParams params}) async {
    final result = await RemoteDataSource.upload(
      withAuthentication: true,
      url: uploadProfileImageUrl,
      responseStr: 'ProfileImageModel',
      converter: (json) => ProfileImageModel.fromJson(json),
      filesMap: {
        'profile_image': [params.file],
      },
    );
    return call(result: result);
  }

  Future<Result<bool>> deleteProfileImage({required DeleteProfileImageParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: deleteProfileImageUrl,
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<SignInModel>> editUser({required EditUserParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: editUserUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'LoginResponse',
        converter: (json) => SignInResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> deleteUser({required DeleteUserParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: deleteUserUrl,
      method: HttpMethod.DELETE,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> toggleUserNotification({required ToggleUserNotificationParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: toggleUserNotificationUrl,
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }
}