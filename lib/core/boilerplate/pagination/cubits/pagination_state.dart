part of 'pagination_cubit.dart';

abstract class PaginationState {}

class PaginationInitial extends PaginationState {}

class Loading extends PaginationState {}

class GetListSuccessfully extends PaginationState {
  final List list;
  final bool noMoreData;

  GetListSuccessfully({required this.list, required this.noMoreData});
}

class Error extends PaginationState {
  final String message;
  Error(this.message);
}
