import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/data_source/remote_data_source.dart';
import 'package:centro_partner/core/http/http_method.dart';
import 'package:centro_partner/core/repository/core_repository.dart';
import 'package:centro_partner/core/results/result.dart';
import 'package:centro_partner/features/auth/data/model/login_model.dart';
import 'package:centro_partner/features/auth/data/model/user_type_model.dart';
import 'package:centro_partner/features/auth/data/usecase/change_password_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/forget_password_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/login_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/logout_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/register_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/resend_code_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/reset_password_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/user_types_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/verify_code_usecase.dart';

class AuthRepository extends CoreRepository {

  Future<Result<bool>> register({required RegisterParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
        withAuthentication: false,
        url: registerUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> verify({required VerifyCodeParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      data: params.toJson(),
      withAuthentication: false,
      url: verifyUrl,
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> resendCode({required ResendCodeParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: false,
      url: resendCodeUrl,
      data: params.toJson(),
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<LoginModel>> login({required LoginParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        url: loginUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
        responseStr: 'LoginResponse',
        converter: (json) => LoginResponse.fromJson(json));
    return call(result: result);
  }

  Future<Result<bool>> forgetPassword({required ForgetPasswordParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
        withAuthentication: false,
        url: forgetPasswordUrl,
        data: params.toJson(),
        method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> resetPassword({required ResetPasswordParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      data: params.toJson(),
      withAuthentication: false,
      url: resetPasswordUrl,
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> changePassword({required ChangePasswordParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      data: params.toJson(),
      withAuthentication: true,
      url: changePasswordUrl,
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<bool>> logout({required LogoutParams params}) async {
    final result = await RemoteDataSource.noModelRequest(
      withAuthentication: true,
      url: logoutUrl,
      method: HttpMethod.POST,
    );
    return noModelCall(result: result);
  }

  Future<Result<UserTypeModel>> getUserTypes({required UserTypesParams params}) async {
    final result = await RemoteDataSource.request(
        withAuthentication: false,
        url: userTypesUrl,
        method: HttpMethod.GET,
        responseStr: 'UserTypeResponse',
        converter: (json) => UserTypeResponse.fromJson(json));
    return call(result: result);
  }

}