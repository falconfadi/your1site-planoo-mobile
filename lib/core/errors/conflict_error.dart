import './http_error.dart';

class ConflictError extends HttpError {
  final int? code;

  const ConflictError({required String? message, this.code})
      : super(message: message);
}
