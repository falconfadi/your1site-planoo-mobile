import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/features/auth/data/model/login_model.dart';
import 'package:centro_partner/features/profile/data/model/profile_image_model.dart';
import 'package:centro_partner/features/profile/data/usecase/delete_profile_image_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/edit_user_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/get_user_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/upload_profile_image_usecase.dart';
import '../../../../core/constants/end_point.dart';
import '../../../../core/data_source/remote_data_source.dart';
import '../../../../core/http/http_method.dart';
import '../../../../core/results/result.dart';

class ProfileRepository extends CoreRepository {

  Future<Result<LoginModel>> getUser({required GetUserParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: getUserUrl,
        method: HttpMethod.GET,
        responseStr: 'LoginResponse',
        converter: (json) => LoginResponse.fromJson(json));
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

  Future<Result<LoginModel>> editUser({required EditUserParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: true,
        url: editUserUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'LoginResponse',
        converter: (json) => LoginResponse.fromJson(json));
    return call(result: result);
  }

}