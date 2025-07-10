import './base_error.dart';

class HttpError extends BaseError {
  const HttpError({this.message, this.messageQraphQl});
  final String? message;
  final String? messageQraphQl;

  @override
  List<Object> get props => [];
}
