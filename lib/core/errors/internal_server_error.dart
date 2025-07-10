import './http_error.dart';

class InternalServerError extends HttpError {
  InternalServerError() : super(message: 'server_err');
}
