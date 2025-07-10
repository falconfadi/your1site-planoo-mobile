import 'package:equatable/equatable.dart';

abstract class BaseError extends Equatable {
  const BaseError({
    this.message,
  });
  final String? message;
}

class MessageModel {
  MessageModel({required this.message});
  final String message;
}
