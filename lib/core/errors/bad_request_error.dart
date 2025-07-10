import './http_error.dart';

class BadRequestError extends HttpError {
  const BadRequestError({required this.message});
  @override
  final String? message;
}
