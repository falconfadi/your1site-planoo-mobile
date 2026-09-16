import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/general/data/general_repository/general_repository.dart';
import 'package:centro_partner/features/general/data/model/main_court/main_court_details_model.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/create_main_court_usecase.dart';
import 'package:centro_partner/features/general/data/usecase/main_court/edit_main_court_usecase.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddMainCourtWidget extends StatefulWidget {

  final bool? isEdit;
  final bool? isHome;
  final VoidCallback? onRefresh;
  final MainCourtDetailsModel? mainCourt;

  const AddMainCourtWidget({super.key,
    this.isEdit = false,
    this.isHome = false,
    this.onRefresh,
    this.mainCourt
  });

  @override
  State<AddMainCourtWidget> createState() => _AddMainCourtWidgetState();
}

class _AddMainCourtWidgetState extends State<AddMainCourtWidget> with FormStateMinxin {

  @override
  void initState() {
    super.initState();
    if(widget.isEdit == true) {
      form.controllers[0].text = widget.mainCourt!.name!;
      form.controllers[1].text = widget.mainCourt!.description ?? "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.isHome == true ? 0.9.sw : null,
      decoration: widget.isHome == true ? BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.r),
      ) : null,
      padding: widget.isHome == true?
      EdgeInsets.only(left: 20.w, right: 20.w, top: 25.h) : EdgeInsets.zero,
      child: Form(
        key: form.key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(widget.isHome == true)...[
              Text(
                AppLocalization.of(context).translate("welcome_Create_first_court"),
                style: AppTheme.headlineSmall.copyWith(color: AppColors.primaryColor),
              ),
              SizedBox(height: 20.h),
            ],
            CustomTextField(
              autoValidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                return BaseValidator.validateValue(
                  context,
                  form.controllers[0].text,
                  [RequiredValidator()],
                );
              },
              focusNode: form.nodes[0],
              textEditingController: form.controllers[0],
              labelText: AppLocalization.of(context).translate("name"),
            ),
            SizedBox(height: 20.h),
            CustomTextField(
              autoFocus: false,
              maxLine: 3,
              autoValidateMode: AutovalidateMode.onUserInteraction,
              focusNode: form.nodes[1],
              textEditingController: form.controllers[1],
              labelText: AppLocalization.of(context).translate("description"),
            ),
            SizedBox(height: 30.h),
            CreateModel(
              withValidation: true,
              loadingHeight: 20.h,
              onTap: () {},
              onSuccess: (model) {
                if(widget.isHome == false) {
                  widget.onRefresh!();
                }
                Navigation.pop();
              },
              useCaseCallBack: (model) {
                if(widget.isEdit != true) {
                  return CreateMainCourtUseCase(GeneralRepository()).call(
                    params: CreateMainCourtParams(
                        name:  form.controllers[0].text,
                        description:  form.controllers[1].text,
                    )
                  );
                } else {
                  return EditMainCourtUseCase(GeneralRepository()).call(
                      params: EditMainCourtParams(
                        mainCourtId: widget.mainCourt!.id!,
                        name:  form.controllers[0].text,
                        description:  form.controllers[1].text,
                      )
                  );
                }
              },
              child: CustomButton(
                width: 1.sw,
                backgroundColor: AppColors.primaryColor,
                borderRadius: 10.r,
                buttonName: AppLocalization.of(context).translate(
                    widget.isEdit == true ? "edit" : "save"),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  @override
  int numberOfFields() => 2;
}

