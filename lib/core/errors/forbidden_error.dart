import './http_error.dart';

class ForbiddenError extends HttpError {

  ForbiddenError({required String message})
      : super(message: message);

}
