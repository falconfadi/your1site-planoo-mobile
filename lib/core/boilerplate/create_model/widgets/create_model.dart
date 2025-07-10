import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/errors/base_error.dart';
import 'package:centro_partner/core/errors/unauthorized_error.dart';
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

  const CreateModel(
      {super.key,
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
  CreateModelCubit<Model>? cubit;

  @override
  void initState() {
    cubit = CreateModelCubit<Model>(widget.useCaseCallBack!);
    if (widget.onCubitCreated != null) {
      widget.onCubitCreated!(cubit!);
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CreateModelCubit, CreateModelState>(
      bloc: cubit,
      builder: (context, state) {
        if (widget.onCubitCreated != null) {
          widget.onCubitCreated!(cubit!);
        }

        if (state is Loading) {
          return SizedBox(height: widget.loadingHeight ?? 50.h, child: const Center(child: LoadingIndicator()));
        } else {
          return InkWell(
              onTap: () {
                if (widget.withValidation) {
                  var temp = widget.onTap!();
                  if (temp != null && temp == true) {
                    cubit?.createModel();
                  }
                } else {
                  cubit?.createModel();
                }
              },
              child: widget.child);
        }
      },
      listener: (context, state) {
        if (state is CreateModelSuccessfully) {
          if (widget.onSuccess != null) widget.onSuccess!(state.model);
        }
        if (state is Error) {
          String errorMessage;
          // Check if state.error has a message property
          if (state.error is BaseError) {
            errorMessage = (state.error as BaseError).message!;
          } else if(state.error is UnauthorizedError) {
            errorMessage = (state.error as UnauthorizedError).message!;
          } else {
            errorMessage = AppLocalization.of(context).translate("an_unknown_error");
          }

          if (widget.onError != null) {
            widget.onError!(errorMessage);
          } else {
            Dialogs.showQuestion(context,title: state.message.toString());
          }
        }
      },
    );
  }
}