import 'dart:io';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/errors/custom_error.dart';
import 'package:centro_partner/core/errors/socket_error.dart';
import '../constants/end_point.dart';
import '../errors/base_error.dart';
import '../http/api_provider.dart';
import '../http/http_method.dart';
import '../http/models_factory.dart';
import '../responses/api_response.dart';
import 'model.dart';

abstract class RemoteDataSource {

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
      final headers = await _buildHeaders(
          withAuthentication: withAuthentication);

      final response = await ApiProvider.sendObjectRequest<Resp>(
        method: method,
        url: url,
        headers: headers,
        queryParameters: queryParameters,
        data: data,
        strString: responseStr,
      );

      debugPrint('Request $url isRight: ${response.isRight()}');

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
      final headers = await _buildHeaders(withAuthentication: withAuthentication);

      final response = await ApiProvider.sendObjectWithOutResponseRequest(
        method: method,
        url: url,
        headers: headers,
        queryParameters: queryParameters,
        data: data,
      );

      debugPrint('No model request $url isRight: ${response.isRight()}');

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
      final headers = await _buildHeaders(withAuthentication: withAuthentication);

      final response = await ApiProvider.uploadFilesWithKeys<Data>(
        url: url,
        filesMap: filesMap,
        data: data,
        headers: headers,
        queryParameters: queryParameters,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        strString: responseStr,
      );

      debugPrint('Upload $url isRight: ${response.isRight()}');

      return response.fold(
            (error) => Left(error),
            (resp) => Right(resp),
      );
    } catch (e) {
      return Left(CustomError(errorMessage: e.toString()));
    }
  }

  static Future<Either<BaseError, void>?> checkTokenValidation() async {
    final String? token = await AppStorage.getData(key: kAccessToken);

    if (token == null) {
      Navigation.pushAndRemoveUntil(SignInScreen());
      return const Left(CustomError(errorMessage: 'No token found'));
    }

    try {
      final decodedToken = JwtDecoder.decode(token);
      int expirationTimestamp = decodedToken['exp'];
      DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);

      final now = DateTime.now();
      final difference = expirationDate.difference(now).inMinutes;

      if (expirationDate.isBefore(now)) {
        await AppStorage.removeData(key: kAccessToken);
        await AppStorage.removeData(key: kAccessTokenExpirationDate);
        await AppStorage.removeData(key: kLastTokenRefresh);

        Navigation.pushAndRemoveUntil(SignInScreen());
        return const Left(CustomError(errorMessage: 'Token expired'));
      } else if (difference <= 15) {
        // Less than 15 minutes left → refresh token if needed
        debugPrint('Checking if we should refresh token…');

        try {
          final lastRefreshStr = await AppStorage.getData(key: kLastTokenRefresh);
          if (lastRefreshStr != null) {
            final lastRefresh = DateTime.parse(lastRefreshStr);
            final sinceLastRefresh = now.difference(lastRefresh).inMinutes;

            // If refreshed within last 150 mins (~2 hours), skip refresh
            if (sinceLastRefresh < 115) {
              debugPrint('Token recently refreshed ($sinceLastRefresh mins ago). Skipping refresh.');
              return Right(null);
            }
          }

          debugPrint('Refreshing token…');
          final response = await Dio().post(
            baseUrl + refreshTokenUrl,
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );

          if (response.statusCode == 200 && response.data['success'] == true) {
            final newToken = response.data['payload']['token'];
            await AppStorage.saveData(key: kAccessToken, value: newToken);
            await AppStorage.saveData(key: kLastTokenRefresh, value: DateTime.now().toIso8601String());
            debugPrint('Token refreshed successfully.');
          } else {
            return const Left(CustomError(errorMessage: 'Failed to refresh token'));
          }
        } on DioError catch (e) {
          if (e.response?.statusCode == 401) {
            await AppStorage.removeData(key: kAccessToken);
            await AppStorage.removeData(key: kAccessTokenExpirationDate);
            await AppStorage.removeData(key: kLastTokenRefresh);
            Navigation.pushAndRemoveUntil(SignInScreen());
          }
        } on SocketException {
          return const Left(SocketError(message: 'Connection error'));
        } catch (e) {
          return Left(CustomError(errorMessage: e.toString()));
        }
      }

      return Right(null); // Token is valid
    } catch (e) {
      return Left(CustomError(errorMessage: e.toString()));
    }
  }


}
