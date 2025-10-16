import 'package:centro_partner/core/ui/widgets/general_error_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../ui/widgets/loading_footer.dart';
import '../../../ui/widgets/no_data_widget.dart';
import '../cubits/pagination_cubit.dart';

typedef CreatedCallback = void Function(PaginationCubit cubit);
typedef ListBuilder<Model> = Widget Function(List<Model> list);

class PaginationList<Model> extends StatefulWidget {
  final RepositoryCallBack repositoryCallBack;
  final ListBuilder<Model>? listBuilder;
  final CreatedCallback? onCubitCreated;
  final bool? withPagination;
  final bool withEmptyWidget;
  final Map<String, dynamic>? initialParam;
  final VoidCallback? onRefresh;
  final Axis scrollDirection;
  final Widget? errorWidget;
  final Widget? noDataWidget;
  final Widget? loadingWidget;

  const PaginationList({super.key,
    this.noDataWidget,
    this.errorWidget,
    this.loadingWidget,
    this.scrollDirection = Axis.vertical,
    required this.repositoryCallBack,
    this.listBuilder,
    this.withPagination = false,
    this.onCubitCreated,
    this.initialParam,
    this.withEmptyWidget = true,
    this.onRefresh
  });

  @override
  State<PaginationList<Model>> createState() => _PaginationListState<Model>();
}

class _PaginationListState<Model> extends State<PaginationList<Model>> {

  final RefreshController _refreshController = RefreshController();
  late final PaginationCubit<Model> cubit;

  @override
  void initState() {
    super.initState();
    cubit = PaginationCubit<Model>(widget.repositoryCallBack);
    widget.onCubitCreated?.call(cubit);
    cubit.getList();
  }

  @override
  void dispose() {
    _refreshController.dispose();
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaginationCubit<Model>, PaginationState>(
        bloc: cubit,
        listener: (context, state) {
          if (state is GetListSuccessfully) {
            widget.onRefresh?.call();
            if (_refreshController.isRefresh) _refreshController.refreshCompleted();
            if (_refreshController.isLoading) {
              state.noMoreData
                  ? _refreshController.loadNoData()
                  : _refreshController.loadComplete();
            }
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return widget.loadingWidget ?? const Center(child: CupertinoActivityIndicator(radius: 15));
          } else if (state is GetListSuccessfully) {
            return smartRefresher(state.list as List<Model>);
          } else if (state is Error) {
            return widget.errorWidget ??
                GeneralErrorWidget(
                  message: state.message,
                  onTap: () {
                    cubit.getList();
                  },
                );
          } else {
            return const SizedBox.shrink();
          }
        }
        );
  }

  SmartRefresher smartRefresher(List<Model> list) {
    Widget child;
    if (list.isEmpty && widget.withEmptyWidget) {
      child = widget.noDataWidget ?? const NoDataWidget();
    } else {
      child = widget.listBuilder!(list);
    }

    return  SmartRefresher(
      scrollDirection: widget.scrollDirection,
      enablePullDown: widget.scrollDirection == Axis.vertical,
      enablePullUp: widget.scrollDirection == Axis.vertical,
      header: const MaterialClassicHeader(),
      controller: _refreshController,
      onRefresh: () async {
        cubit.getList();
      },
      onLoading: () async {
        cubit.getList(loadMore: true);
      },
      footer: customFooter,
      child: child,
    );
  }
}