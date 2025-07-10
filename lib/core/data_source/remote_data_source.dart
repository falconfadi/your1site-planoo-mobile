import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:centro_partner/core/clasess/app_storage.dart';
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
  static Future<Either<BaseError, Data>> request<Data extends BaseModel, Response extends ApiResponse<Data>>({
    required String responseStr,
    required Response Function(Map<String, dynamic>) converter,
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool withAuthentication = false,
  }) async {
    ModelsFactory.getInstance()!.registerModel(responseStr, converter);
    final Map<String, String> headers = {};

    if (withAuthentication) {
      await checkTokenValidation();
      final String token = AppStorage.getData(key: kAccessToken);
      debugPrint(token);
      headers.putIfAbsent(headerAuth, () => 'Bearer $token');
    }
    headers.putIfAbsent(headerLanguageKey, () => '${AppStorage.getData(key: headerLanguageKey)}');
    headers.putIfAbsent(headerAccept, () => 'application/json');
    headers.putIfAbsent(headerContentType, () => 'application/json');
    final response = await ApiProvider.sendObjectRequest<Response>(
      method: method,
      url: url,
      headers: headers,
      queryParameters: queryParameters,
      data: data,
      strString: responseStr,
    );
    debugPrint(response.toString());

    if (kDebugMode) {
      print('is right : ${response.isRight()}');
    }
    debugPrint('is right : ${response.isRight()}');
    if (response.isLeft()) {
      debugPrint('is left');
      return Left((response as Left<BaseError, Response>).value);
    } else {
      debugPrint('response right ${(response as Right<BaseError, Response>).value}');
      final resValue = response.value;
      return Right(resValue.data);
    }
  }

  static Future<Either<BaseError, bool>> noModelRequest({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? data,
    bool withAuthentication = false,
  }) async {
    final Map<String, String> headers = {};

    if (withAuthentication) {
      await checkTokenValidation();
      final String token = AppStorage.getData(key: kAccessToken);
      headers.putIfAbsent(headerAuth, () => 'Bearer $token');
    }
    headers.putIfAbsent(headerLanguageKey, () => '${AppStorage.getData(key: headerLanguageKey)}');
    headers.putIfAbsent(headerAccept, () => 'application/json');
    headers.putIfAbsent(headerContentType, () => 'application/json');
    final response = await ApiProvider.sendObjectWithOutResponseRequest(
      method: method,
      url: url,
      headers: headers,
      queryParameters: queryParameters,
      data: data,
    );

    if (kDebugMode) {
      print('is right : ${response.isRight()}');
    }
    debugPrint('is right : ${response.isRight()}');
    if (response.isLeft()) {
      debugPrint('is left');
      return Left((response as Left<BaseError, bool>).value);
    } else {
      debugPrint('response right ${(response as Right<BaseError, bool>).value}');
      final resValue = response;
      return resValue;
    }
  }

  static Future<Either<BaseError, void>?> checkTokenValidation() async {
    final String? token = await AppStorage.getData(key: kAccessToken);

    if (token == null) {
      // Navigation.pushAndRemoveUntil(LoginScreen()); // todo later
      return const Left(CustomError(errorMessage: 'No token found'));
    }

    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      int expirationTimestamp = decodedToken['exp'];
      DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);

      final now = DateTime.now();
      final difference = expirationDate.difference(now).inMinutes;

      if (expirationDate.isBefore(now)) {
        await AppStorage.removeData(key: kAccessToken);
        await AppStorage.removeData(key: kAccessTokenExpirationDate);

        // Navigation.pushAndRemoveUntil(LoginScreen()); // todo later
        return const Left(CustomError(errorMessage: 'Token expired'));
      } else if (difference <= 5) {
        // Less than 5 minute left → refresh token
        debugPrint('Refreshing token…');
        try {
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
          } else {
            return const Left(CustomError(errorMessage: 'Failed to refresh token'));
          }
        } on DioError catch (e) {
          if (e.response?.statusCode == 401) {
            await AppStorage.removeData(key: kAccessToken);
            await AppStorage.removeData(key: kAccessTokenExpirationDate);
            // Navigation.pushAndRemoveUntil(LoginScreen()); // todo later
          }
          return const Left(SocketError(message: ''));
        } on SocketException {
          return const Left(SocketError(message: 'Connection error'));
        } catch (e) {
          return const Left(CustomError(errorMessage: 'Unexpected error'));
        }
      }

      return Right(null); // Token is valid
    } catch (e) {
      debugPrint('Error checking token: $e');
      return const Left(CustomError(errorMessage: 'Failed to parse token'));
    }
  }

  static Future<Either<BaseError, Data>> upload<Data>({
    required String responseStr,
    required Data Function(Map<String, dynamic>) converter,
    required String url,
    required Map<String, List<File>> filesMap, // <- updated
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    bool withAuthentication = false,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    ModelsFactory.getInstance()!.registerModel(responseStr, converter);
    final Map<String, String> headers = {};

    if (withAuthentication) {
      await checkTokenValidation();
      final String token = AppStorage.getData(key: kAccessToken);
      debugPrint(token);
      headers.putIfAbsent(headerAuth, () => 'Bearer $token');
    }
    headers.putIfAbsent(headerAccept, () => 'application/json');
    headers.putIfAbsent(headerContentType, () => 'application/json');
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

    print('is right : ${response.isRight()}');
    if (response.isLeft()) {
      print('is left');
      return Left((response as Left<BaseError, Data>).value);
    } else {
      print('response right ${(response as Right<BaseError, Data>).value}');
      return Right((response).value);
    }
  }
}
