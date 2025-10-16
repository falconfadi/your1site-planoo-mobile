import 'package:centro_partner/core/results/result.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/get_list_request.dart';
part 'pagination_state.dart';

typedef RepositoryCallBack = Future<Result?> Function(dynamic data);

class PaginationCubit<ListModel> extends Cubit<PaginationState> {

  final RepositoryCallBack getData;

  PaginationCubit(this.getData) : super(PaginationInitial());

  List<ListModel> list = [];
  Map<String, dynamic> params = {};
  int limit = 10;
  int page = 1;
  String order = 'asc';

  Future<void> getList({bool loadMore = false}) async {
    if (!loadMore) {
      page = 1;
      emit(Loading());
    } else {
      page++;
    }

    try {
      final requestData = GetListRequest(
        limit: limit,
        page: page,
        order: order,
      );
      var response = await getData(requestData);

      if (response == null) {
        emit(PaginationInitial());
        return;
      }

      if (response.hasDataOnly) {
        final newData = response.data as List<ListModel>;

        if (loadMore) {
          list.addAll(newData);
        } else {
          list = newData;
        }

        emit(GetListSuccessfully(
          list: list.toList(),
          noMoreData: newData.isEmpty,
        ));
      } else if (response.hasErrorOnly) {
        if (loadMore) {
          emit(GetListSuccessfully(
            list: list.toList(),
            noMoreData: true,
          ));
        } else {
          emit(Error(response.error!.message.toString()));
        }
      } else {
        emit(PaginationInitial());
      }
    } catch(e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  void reset() {
    list.clear();
    page = 1;
    emit(PaginationInitial());
  }
}