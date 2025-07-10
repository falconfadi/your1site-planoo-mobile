import 'base_error.dart';

class TimeoutError extends BaseError {
  const TimeoutError({this.errorMessage}) : super(message: errorMessage);
  final String? errorMessage;
  @override
  List<Object?> get props => throw UnimplementedError();
}
