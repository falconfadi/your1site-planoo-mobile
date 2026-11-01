import 'dart:async';
import 'dart:io';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/errors/custom_error.dart';
import '../constants/end_point.dart';
import '../errors/base_error.dart';
import '../errors/unauthorized_error.dart';
import '../http/api_provider.dart';
import '../http/http_method.dart';
import '../http/models_factory.dart';
import '../responses/api_response.dart';
import 'model.dart';

abstract class RemoteDataSource {

  static Completer<bool>? _refreshCompleter;

  static Future<Map<String, String>> _buildHeaders({bool withAuthentication = false}) async {
    final Map<String, String> headers = {
      headerLanguageKey: '${await AppStorage.getData(key: headerLanguageKey) ?? 'en'}',
      headerAccept: 'application/json',
      headerContentType: 'application/json',
    };

    if (withAuthentication) {
     await checkTokenValidation();

      final String? token = await AppStorage.getData(key: kAccessToken);
      if (token != null) headers[headerAuth] = 'Bearer $token';
    }

    return headers;
  }

  static Future<Either<BaseError, Data>> request<Data extends BaseModel, Resp extends ApiResponse<Data>>({
    required String responseStr,
    required Resp Function(Map<String, dynamic>) converter,
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool withAuthentication = false,
  }) async {
    ModelsFactory.getInstance()!.registerModel(responseStr, converter);

    try {
      final response = await _sendWithAuthRetry(
        withAuthentication: withAuthentication,
        send: (headers) => ApiProvider.sendObjectRequest<Resp>(
          method: method,
          url: url,
          headers: headers,
          queryParameters: queryParameters,
          data: data,
          strString: responseStr,
        ),
      );


      return response.fold(
            (error) => Left(error),
            (resp) => Right(resp.data),
      );
    } catch (e) {
      return Left(CustomError(errorMessage: e.toString()));
    }
  }

  static Future<Either<BaseError, bool>> noModelRequest({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool withAuthentication = false,
  }) async {
    try {
      final response = await _sendWithAuthRetry(
        withAuthentication: withAuthentication,
        send: (headers) => ApiProvider.sendObjectWithOutResponseRequest(
          method: method,
          url: url,
          headers: headers,
          queryParameters: queryParameters,
          data: data,
        ),
      );


      return response.fold(
            (error) => Left(error),
            (value) => Right(value),
      );
    } catch (e) {
      return Left(CustomError(errorMessage: e.toString()));
    }
  }

  static Future<Either<BaseError, Data>> upload<Data>({
    required String responseStr,
    required Data Function(Map<String, dynamic>) converter,
    required String url,
    required Map<String, List<File>> filesMap,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool withAuthentication = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    ModelsFactory.getInstance()!.registerModel(responseStr, converter);
    try {
      final response = await _sendWithAuthRetry(
        withAuthentication: withAuthentication,
        send: (headers) => ApiProvider.uploadFilesWithKeys<Data>(
          url: url,
          filesMap: filesMap,
          data: data,
          headers: headers,
          queryParameters: queryParameters,
          cancelToken: cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          strString: responseStr,
        ),
      );


      return response.fold(
            (error) => Left(error),
            (resp) => Right(resp),
      );
    } catch (e) {
      return Left(CustomError(errorMessage: e.toString()));
    }
  }

  static Future<Either<BaseError, T>> _sendWithAuthRetry<T>({
    required bool withAuthentication,
    required Future<Either<BaseError, T>> Function(Map<String, String> headers) send,
  }) async {
    final headers = await _buildHeaders(withAuthentication: withAuthentication);
    final result = await send(headers);

    final isUnauthorized = result.fold((error) => error is UnauthorizedError, (_) => false);
    final sentToken = headers[headerAuth]?.replaceFirst('Bearer ', '');
    if (!withAuthentication || !isUnauthorized || sentToken == null) return result;

    if (!await _refreshOnce(sentToken)) {
      await _logout();
      return result;
    }

    return send(await _buildHeaders(withAuthentication: true));
  }

  static Future<void> checkTokenValidation() async {
    final String? token = await AppStorage.getData(key: kAccessToken);

    if (token == null) {
      await _logout();
      return;
    }

    final decodedToken = JwtDecoder.decode(token);
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);

    final hoursLeft = expirationDate.difference(DateTime.now()).inHours;

    if (hoursLeft < 24) {
      // Token expired or about to expire, refresh
      if (!await _refreshOnce(token)) await _logout();
    }
  }

  static Future<bool> _refreshOnce(String sentToken) async {
    final String? token = await AppStorage.getData(key: kAccessToken);
    if (token == null) return false;

    // Refresh already in progress, wait for it
    if (_refreshCompleter != null) return _refreshCompleter!.future;

    if (token != sentToken) return true;

    final completer = _refreshCompleter = Completer<bool>();
    var success = false;
    try {
      success = await _refreshToken(token);
    } finally {
      completer.complete(success);
      _refreshCompleter = null;
    }
    return success;
  }

  static Future<bool> _refreshToken(String token) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        baseUrl + refreshTokenUrl,
        options: Options(headers: {
          headerAuth: 'Bearer $token',
          headerAccept: 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        final newToken = response.data['payload']['token'];
        await saveLoginTokens(newToken);
        return true;
      }
    } catch (_) {}
    return false;
  }

  static Future<void> saveLoginTokens(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(decodedToken['exp'] * 1000);

    await AppStorage.saveData(key: kAccessToken, value: token);
    await AppStorage.saveData(key: kAccessTokenExpirationDate, value: expirationDate.toIso8601String());
  }


  static Future<void> _logout() async {
    await AppStorage.removeData(key: kAccessToken);
    await AppStorage.removeData(key: kAccessTokenExpirationDate);
    Navigation.pushAndRemoveUntil(SignInScreen());
  }
}