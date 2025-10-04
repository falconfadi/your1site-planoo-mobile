import 'package:centro_partner/core/errors/base_error.dart';

/// used for testing
class TestError extends BaseError {

  const TestError({super.message});

  @override
  List<Object?> get props => [message];
}