import 'http_error.dart';

class NetError extends HttpError {

  const NetError({required String message}) : super(message: message);

}
