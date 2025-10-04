import './http_error.dart';

class ForbiddenError extends HttpError {

  const ForbiddenError({required String message})
      : super(message: message);

}
