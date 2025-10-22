import 'dart:convert';
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../constants/end_point.dart';
import '../errors/bad_request_error.dart';
import '../errors/base_error.dart';
import '../errors/cancel_error.dart';
import '../errors/conflict_error.dart';
import '../errors/custom_error.dart';
import '../errors/forbidden_error.dart';
import '../errors/http_error.dart';
import '../errors/internal_server_error.dart';
import '../errors/not_found_error.dart';
import '../errors/socket_error.dart';
import '../errors/timeout_error.dart';
import '../errors/unauthorized_error.dart';
import '../errors/unknown_error.dart';
import 'http_method.dart';
import 'models_factory.dart';


class ApiProvider {

  static final BaseOptions options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: kIsWeb ? const Duration(milliseconds: 0) : const Duration(
          milliseconds: 30000),
      receiveTimeout: kIsWeb ? const Duration(milliseconds: 0) : const Duration(
          milliseconds: 30000),
      followRedirects: false,
      maxRedirects: 0,
      validateStatus: (status) {
        return status != null && status < 500;
      }
  );

  static final Dio dio = Dio(options);


  static Future<Either<BaseError, T>> uploadFilesWithKeys<T>({
    required String url,
    required Map<String, List<File>> filesMap,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
    required String strString,
  }) async {
    final Map<String, dynamic> dataMap = {...?data};

    if (queryParameters != null) {
      queryParameters = Map<String, dynamic>.from(queryParameters);
    }

    for (final entry in filesMap.entries) {
      final List<File> fileList = entry.value;

      final multipartList = await Future.wait(fileList.map((file) async {
        final fileName = file.path.split("/").last;
        return MultipartFile.fromFile(file.path, filename: fileName);
      }));

      dataMap[entry.key] = multipartList.length == 1 ? multipartList.first : multipartList;
    }

    dataMap['MnD'] = 'MnD';

    try {
      final response = await dio.post(
        url,
        data: FormData.fromMap(dataMap),
        options: Options(headers: headers),
        queryParameters: queryParameters,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );

      final decodedJson = _normalizeResponse(response.data);
      debugPrint('response : $decodedJson');
      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        if ((decodedJson['message'] ?? '').isNotEmpty && decodedJson['payload'] != null) {
          return Right(ModelsFactory.getInstance()!.createModel<T>(decodedJson, strString));
        }
      }
      return Left(CustomError(errorMessage: _extractErrorMessage(decodedJson)));
    } on DioError catch (e) {
      return Left(handleDioError(e));
    } on SocketException {
      return Left(const SocketError(message: 'please check your connection'));
    }
  }

  static Future<Either<BaseError, T>> sendObjectRequest<T>({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    required String strString,
  }) async {
    try {
      debugPrint('[${method.name}: $url] data : [$data]');
      debugPrint('queryParameters : [$queryParameters]');
      debugPrint(jsonEncode(data));

      final response = await _sendRequest(method, url, data, headers, queryParameters);
      final decodedJson = _normalizeResponse(response.data);

      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        if ((decodedJson['message'] ?? '').isNotEmpty && decodedJson['payload'] != null) {
          return Right(ModelsFactory.getInstance()!.createModel<T>(decodedJson, strString));
        }
      }
      return Left(CustomError(errorMessage: _extractErrorMessage(decodedJson)));
    } on DioException catch (e) {
      return Left(handleDioError(e));
    } on SocketException {
      return const Left(SocketError(message: 'please check your connection'));
    }
  }

  static Future<Either<BaseError, bool>> sendObjectWithOutResponseRequest<T>({
    required HttpMethod method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      debugPrint('[${method.name}: $url] data : [$data]');
      debugPrint('queryParameters : [$queryParameters]');
      debugPrint(jsonEncode(data));

      final response = await _sendRequest(method, url, data, headers, queryParameters);
      final decodedJson = _normalizeResponse(response.data);

      if ((response.statusCode ?? 0) >= 200 && (response.statusCode ?? 0) < 300) {
        if ((decodedJson['message'] ?? '').isNotEmpty || decodedJson['status'] != null) {
          return const Right(true);
        }
      }

      return Left(CustomError(errorMessage: _extractErrorMessage(decodedJson)));
    } on DioError catch (e) {
      return Left(handleDioError(e));
    } on SocketException {
      return const Left(SocketError(message: 'please check your connection'));
    }
  }

  static Future<Response> _sendRequest(
      HttpMethod method,
      String url,
      Map<String, dynamic>? data,
      Map<String, String>? headers,
      Map<String, dynamic>? queryParameters,
      ) async {
    final options = Options(headers: headers);
    switch (method) {
      case HttpMethod.GET:
        return await dio.get(url, queryParameters: queryParameters, options: options);
      case HttpMethod.POST:
        return await dio.post(url, data: data, queryParameters: queryParameters, options: options);
      case HttpMethod.PUT:
        return await dio.put(url, data: data, queryParameters: queryParameters, options: options);
      case HttpMethod.DELETE:
        return await dio.delete(url, data: data, queryParameters: queryParameters, options: options);
      case HttpMethod.PATCH:
        return await dio.patch(url, data: data, queryParameters: queryParameters, options: options);
    }
  }

  static Map<String, dynamic> _normalizeResponse(dynamic data) {
    final decoded = data is String ? json.decode(data) : data;
    if (decoded['payload'] == false || decoded['payload'] == true) {
      decoded['payload'] = {'': ''};
    }
    decoded['payload'] ??= {'id': 0, 'file': ''};
    return decoded;
  }

  static BaseError handleDioError(DioException error) {
    if (kDebugMode) debugPrint('error : $error');

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutError(errorMessage: 'Please check your connection');
    } else if (error.type == DioExceptionType.cancel) {
      return CancelError();
    } else if (error.type == DioExceptionType.unknown) {
      return UnknownError();
    }

    final responseData = error.response?.data;
    if (responseData != null) {
      try {
        final decodedJson = responseData is String ? jsonDecode(responseData) : responseData;
        switch (error.response!.statusCode) {
          case 400:
            return BadRequestError(message: _extractErrorMessage(decodedJson));
          case 401:
            return UnauthorizedError(message: _extractErrorMessage(decodedJson));
          case 403:
            return ForbiddenError(message: decodedJson["error"]);
          case 404:
            return NotFoundError(message: decodedJson['message'], code: decodedJson['code']);
          case 409:
            return ConflictError(message: decodedJson['message'], code: decodedJson['code']);
          case 500:
            return InternalServerError();
          default:
            return HttpError(message: _extractErrorMessage(decodedJson));
        }
      } catch (e) {
        debugPrint('Error parsing response: $e');
        return const HttpError(message: 'An unknown error occurred');
      }
    }

    return const HttpError(message: 'An unknown error occurred');
  }

  static String _extractErrorMessage(Map<String, dynamic> decodedJson) {
    final payload = decodedJson["payload"];
    if (payload is Map<String, dynamic> && payload.containsKey("errors")) {
      final errors = payload["errors"];
      final List<String> errorMessages = [];

      if (errors is Map<String, dynamic>) {
        debugPrint("Extracting errors from Map<String, List>");
        errors.forEach((_, value) {
          if (value is List) {
            errorMessages.addAll(value.map((e) => e.toString()));
          }
        });
      } else if (errors is List) {
        debugPrint("Extracting errors from List<Map<String, List>>");
        for (final item in errors) {
          if (item is Map<String, dynamic>) {
            item.forEach((_, value) {
              if (value is List) {
                errorMessages.addAll(value.map((e) => e.toString()));
              }
            });
          }
        }
      } else if (errors is String) {
        debugPrint("Extracting errors from String");
        return errors;
      }

      if (errorMessages.isNotEmpty) {
        return errorMessages.join(" ");
      }
    }

    final message = decodedJson["message"];
    if (message is String && message.trim().isNotEmpty) {
      return message;
    }

    return "An unknown error occurred";
  }
}