import 'http_error.dart';

class SocketError extends HttpError {

  const SocketError({required String message}) : super(message: message);

}
