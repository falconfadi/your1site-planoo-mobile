import 'package:equatable/equatable.dart';

abstract class BaseModel extends Equatable {
  final String? id;
  const BaseModel({this.id});
  @override
  // TODO: implement props
  List<Object?> get props => [id];
}