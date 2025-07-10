import './http_error.dart';

class UnauthorizedError extends HttpError {
  const UnauthorizedError({required this.message});
  @override
  final String? message;
}
