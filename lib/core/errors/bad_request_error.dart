import './http_error.dart';

class BadRequestError extends HttpError {

  const BadRequestError({required String message}) : super(message: message);

}
