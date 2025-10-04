import './http_error.dart';

class NotFoundError extends HttpError {
  final int? code;

  const NotFoundError({required String message, this.code})
      : super(message: message);
}
