import './http_error.dart';

class UnauthorizedError extends HttpError {

  const UnauthorizedError({required String message}) : super(message: message);

}
