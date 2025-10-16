import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../ui/widgets/general_error_widget.dart';
import '../../../ui/widgets/loading.dart';
import '../cubits/get_model_cubit.dart';

typedef CreatedCallback = void Function(GetModelCubit cubit);
typedef ModelBuilder<Model> = Widget Function(Model model);
typedef ModelReceived<Model> = Function(Model model);

class GetModel<Model> extends StatefulWidget {
  final double? loadingHeight;
  final Widget? loading;
  final ModelBuilder<Model>? modelBuilder;
  final ModelReceived<Model>? onSuccess;
  final UseCaseCallBack useCaseCallBack;
  final CreatedCallback? onCubitCreated;

  const GetModel({
    super.key,
    this.loadingHeight,
    this.loading,
    this.modelBuilder,
    this.onSuccess,
    required this.useCaseCallBack,
    this.onCubitCreated,
  });

  @override
  State<GetModel<Model>> createState() => _GetModelState<Model>();
}

class _GetModelState<Model> extends State<GetModel<Model>> {

  late final GetModelCubit<Model> cubit;

  @override
  void initState() {
    cubit = GetModelCubit<Model>(widget.useCaseCallBack);
    widget.onCubitCreated?.call(cubit);
    cubit.getModel();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GetModelCubit, GetModelState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is Loading) {
          return SizedBox(
              height: widget.loadingHeight,
              child: Center(child: widget.loading ?? const LoadingIndicator())
          );
        }
        else {
          if (state is GetModelSuccessfully) {
            return _buildModel(state.model);
          } else if (state is Error) {
            return GeneralErrorWidget(
              message: state.message,
              onTap: cubit.getModel,
            );
          } else {
            return const SizedBox.shrink();
          }
        }
      },
      listener: (context, state) {
        if (state is GetModelSuccessfully) {
          widget.onSuccess?.call(state.model);
        }
      },
    );
  }

  Widget _buildModel(Model model) {
    if (widget.modelBuilder == null) return const SizedBox.shrink();
    return RefreshIndicator(
      onRefresh: () async => await cubit.getModel(),
      child: widget.modelBuilder!(model),
    );
  }
}