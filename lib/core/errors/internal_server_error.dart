import './http_error.dart';

class InternalServerError extends HttpError {
  const InternalServerError() : super(message: 'server_err');
}
