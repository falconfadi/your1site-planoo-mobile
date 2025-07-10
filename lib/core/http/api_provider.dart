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

  static var options = BaseOptions(
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
    final Map<String, dynamic> dataMap = {};
    if (data != null) {
      dataMap.addAll(data);
    }

    if (queryParameters != null) {
      queryParameters = Map<String, dynamic>.from(queryParameters);
    }

    for (final entry in filesMap.entries) {
      final List<File> fileList = entry.value;
      List<MultipartFile> multipartList = [];

      for (final file in fileList) {
        final fileName = file.path.split("/").last;
        multipartList.add(await MultipartFile.fromFile(file.path, filename: fileName));
      }

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

      var decodedJson = response.data is String ? json.decode(response.data) : response.data;

      decodedJson['payload'] ??= {'id': 0, 'file': ''};

      debugPrint('respooooooonse : $decodedJson');
      return Right(ModelsFactory.getInstance()!.createModel<T>(decodedJson, strString));
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
      debugPrint('[$method: $url] data : [$data]');
      debugPrint('queryParameters : [$queryParameters]');

      dio.options.headers = headers;

      debugPrint(jsonEncode(data));

      Response response;
      switch (method) {
        case HttpMethod.GET:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.POST:
          response = await dio.post(
            url,
            data: data,
            queryParameters: queryParameters ?? {},
          );

          break;
        case HttpMethod.PUT:
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.DELETE:
          response = await dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
          );
        case HttpMethod.PATCH:
          response = await dio.patch(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }

      var decodedJson;

      if (response.data is String) {
        debugPrint(response.toString());
        decodedJson = json.decode(response.data);
        debugPrint(decodedJson);
      } else {
        decodedJson = response.data;
      }

      if (decodedJson['payload'] == false || decodedJson['payload'] == true)
        decodedJson['payload'] = {'': ''};
      if (kDebugMode) {
        printWrapped(decodedJson.toString());
      }

      if ((response.statusCode)! > 199 && (response.statusCode)! < 300) {
        if (decodedJson['message'] != null || decodedJson['message'] != "") {
          if (decodedJson['payload'] != null) {
            return Right(ModelsFactory.getInstance()!.createModel<T>(
                decodedJson, strString));
          } else {
            return Left(CustomError(
                errorMessage: _extractErrorMessage(decodedJson)
            ));
          }
        } else {
          return Left(CustomError(
            errorMessage: _extractErrorMessage(decodedJson)
          ));
        }
      } else {
        return Left(CustomError(
          errorMessage: _extractErrorMessage(decodedJson)
        ));
      }
    }

    on DioException catch (e) {
      print(e.response);
      return Left(handleDioError(e));
    }

    on SocketException catch (e, stacktrace) {
      print(e);
      print(stacktrace);
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
      debugPrint('lllllllllllllllllllllllllllllllll$headers');
      debugPrint('[$method: $url] data : [$data]');
      debugPrint('queryParameters : [$queryParameters]');

      debugPrint(jsonEncode(data));

      dio.options.headers = headers;

      Response response;
      switch (method) {
        case HttpMethod.GET:
          response = await dio.get(
            url,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.POST:
          response = await dio.post(
            url,
            data: data,
            queryParameters: queryParameters ?? {},
          );
          break;
        case HttpMethod.PUT:
          response = await dio.put(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
        case HttpMethod.DELETE:
          response = await dio.delete(
            url,
            data: data,
            queryParameters: queryParameters,
          );
        case HttpMethod.PATCH:
          response = await dio.patch(
            url,
            data: data,
            queryParameters: queryParameters,
          );
          break;
      }

      var decodedJson;

      if (response.data is String) {
        if (response.data == "") {
          return const Right(true);
        } else {
          decodedJson = json.decode(response.data);
        }
      } else {
        decodedJson = response.data;
      }

      if (decodedJson['payload'] == false || decodedJson['payload'] == true)
        decodedJson['payload'] = {'': ''};
      if (kDebugMode) {
        printWrapped(decodedJson.toString());
      }

      if ((response.statusCode)! > 199 && (response.statusCode)! < 300) {
        if (decodedJson['message'] != null && decodedJson['message'] != "") {
          return const Right(true);
        } else if (decodedJson['status'] != null) {
          return const Right(true);
        } else {
          return Left(CustomError(
              errorMessage: _extractErrorMessage(decodedJson)
          ));
        }
      }
      else {
        return Left(CustomError(
            errorMessage: _extractErrorMessage(decodedJson)
        ));
      }
    }

    on DioError catch (e) {
      print(e.message);
      return Left(handleDioError(e));
    }

    // Couldn't reach out the server
    on SocketException catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      return const Left(SocketError(message: 'please check your connection'));
    }
  }

  static void printWrapped(String text) {
    final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
    pattern.allMatches(text).forEach((match) => print(match.group(0)));
  }

  static BaseError handleDioError(DioException error) {
    if (kDebugMode) {
      print('error : $error');
    }

    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout) {
      return const TimeoutError(errorMessage: 'Please check your connection');
    } else if (error.type == DioExceptionType.cancel) {
      return CancelError();
    } else if (error.type == DioExceptionType.unknown) {
      return UnknownError();
    } else {
      if (error is SocketException) {
        return const SocketError(message: 'Please check your connection');
      }

      if (error.response != null && error.response!.data != null) {
        final responseData = error.response!.data;

        try {
          Map<String, dynamic> decodedJson;

          if (responseData is String) {
            print('1');
            // If the response is a string, try to decode it
            decodedJson = jsonDecode(responseData);
          } else if (responseData is Map<String, dynamic>) {
            print('2');
            // If responseData is already a decoded JSON object
            decodedJson = responseData;
          } else {
            print('3');
            return const HttpError(message: 'An unknown error occurred');
          }

          switch (error.response!.statusCode) {
            case 400:
              return BadRequestError(
                  message: _extractErrorMessage(decodedJson));
            case 401:
              return UnauthorizedError(message: _extractErrorMessage(decodedJson));
            case 403:
              return ForbiddenError(message: decodedJson["error"]);
            case 404:
              return NotFoundError(
                  message: decodedJson['message'], code: decodedJson['code']);
            case 409:
              return ConflictError(
                  message: decodedJson['message'], code: decodedJson['code']);
            case 500:
              debugPrint(decodedJson.toString());
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
  }

  static String _extractErrorMessage(Map<String, dynamic> decodedJson) {
    if (decodedJson.containsKey("payload") &&
        decodedJson["payload"] != null &&
        decodedJson["payload"].containsKey("errors")) {

      final errors = decodedJson["payload"]["errors"];

      List<String> errorMessages = [];

      if (errors is Map<String, dynamic> && errors.isNotEmpty) {
        // Case 1: If `errors` is a Map (key-value pair)
        print("1");
        errors.forEach((key, value) {
          if (value is List && value.isNotEmpty) {
            errorMessages.addAll(value.map((e) => e.toString())); // Convert to string
          }
        });
      } else if (errors is List && errors.isNotEmpty) {
        print("2");
        // Case 2: If `errors` is a List (array of objects)
        for (var errorItem in errors) {
          if (errorItem is Map<String, dynamic>) {
            errorItem.forEach((key, value) {
              if (value is List && value.isNotEmpty) {
                errorMessages.addAll(value.map((e) => e.toString()));
              }
            });
          }
        }
      } else {
        // Case 3: errors is string
        return errors;
      }

      if (errorMessages.isNotEmpty) {
        return errorMessages.join(" "); // Join all messages with space
      }
    }

    // If no specific error messages found, return the general message
    if (decodedJson.containsKey("message") && decodedJson["message"] is String) {
      return decodedJson["message"];
    }

    return "An unknown error occurred";
  }
}