import './base_error.dart';

class HttpError extends BaseError {

  const HttpError({super.message, this.messageQraphQl});

  final String? messageQraphQl;

  @override
  List<Object> get props => [message ?? '', messageQraphQl ?? ''];
}