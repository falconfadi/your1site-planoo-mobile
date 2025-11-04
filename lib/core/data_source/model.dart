import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  final String? id;
  const BaseModel({this.id});

  @override
  List<Object?> get props => [id];
}