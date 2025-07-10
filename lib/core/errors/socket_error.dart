import 'http_error.dart';

class SocketError extends HttpError {
  const SocketError({required this.message});
  @override
  final String? message;
}
