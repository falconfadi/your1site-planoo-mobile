import 'package:centro_partner/core/results/result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/get_list_request.dart';
part 'pagination_state.dart';

typedef RepositoryCallBack = Future<Result>? Function(dynamic data);

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

    var requestData = GetListRequest(
      limit: limit,
      page: page,
      order: order,
    );
    var response = await getData(requestData);

    // // todo change it if the api get error when list is empty
    // if (response == null) {
    //   emit(PaginationInitial());
    // } else {
    //   if (response.hasDataOnly) {
    //     if (loadMore) {
    //       list.addAll(response.data as List<ListModel>);
    //     } else {
    //       list = response.data as List<ListModel>;
    //     }
    //
    //     emit(GetListSuccessfully(
    //         list: list.toList(),
    //         noMoreData: (response.data.toSet().toList() as List<ListModel>).isEmpty && loadMore));
    //   } else if (response.hasErrorOnly) {
    //     if (response.error?.message != null) {
    //       emit(Error(response.error!.message!));
    //     }/* else {
    //       emit(Error('Some Thing went wrong'));
    //     }*/
    //   } else {
    //     emit(PaginationInitial());
    //   }
    // }
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
      // 🛠 Handle error on load more gracefully
      if (loadMore) {
        // If it's a "no more data" error, just emit current list
        emit(GetListSuccessfully(
          list: list.toList(),
          noMoreData: true,
        ));
      } else {
        emit(Error(response.error?.message ?? 'Something went wrong'));
      }
    } else {
      emit(PaginationInitial());
    }
  }
}