import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../ui/dialogs/dialogs.dart';
import '../../../ui/widgets/loading.dart';
import '../cubits/create_model_cubit.dart';

typedef CreatedCallback = void Function(CreateModelCubit cubit);
typedef ModelCreated<Model> = Function(Model model);

class CreateModel<Model> extends StatefulWidget {
  final ModelCreated<Model>? onSuccess;
  final double? loadingHeight;
  final UseCaseCallBack? useCaseCallBack;
  final CreatedCallback? onCubitCreated;
  final Widget child;
  final Function? onTap;
  final bool withValidation;
  final Function? onError;

  const CreateModel({super.key,
    this.useCaseCallBack,
    this.onTap,
    this.onCubitCreated,
    required this.child,
    this.onSuccess,
    required this.withValidation,
    this.loadingHeight,
    this.onError,
  });

  @override
  State<CreateModel<Model>> createState() => _GetModelState<Model>();
}

class _GetModelState<Model> extends State<CreateModel<Model>> {

  late final CreateModelCubit<Model> cubit;

  @override
  void initState() {
    super.initState();
    cubit = CreateModelCubit(widget.useCaseCallBack!);
    widget.onCubitCreated?.call(cubit);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateModelCubit, CreateModelState>(
      bloc: cubit,
      builder: (context, state) {
        if (state is Loading) {
          return SizedBox(
            height: widget.loadingHeight ?? 50.h,
            child: const Center(child: LoadingIndicator()),
          );
        }
        return InkWell(
          onTap: () {
            final shouldCreate = widget.onTap?.call() ?? true;
            if (widget.withValidation && !shouldCreate) return;
            cubit.createModel();
          },
          child: widget.child,
        );
      },
      listener: (context, state){
        if (state is CreateModelSuccessfully) {
          widget.onSuccess?.call(state.model);
        } else if (state is Error) {
          if (!context.mounted) return;
          final message = state.error?.message ?? AppLocalization.of(context).translate("an_unknown_error");
          if (widget.onError != null) {
            widget.onError!(message);
          } else {
            Dialogs.showQuestion(context, title: message);
          }
        }
      },
    );
  }
}