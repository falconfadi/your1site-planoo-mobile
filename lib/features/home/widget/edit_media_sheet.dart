import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';

class EditMediaSheet extends StatefulWidget {

  EditMediaSheet({Key? key}) : super(key: key);

  @override
  State<EditMediaSheet> createState() => _EditMediaSheetState();
}

class _EditMediaSheetState extends State<EditMediaSheet>  with FormStateMinxin {

  @override
  Widget build(BuildContext context) {
    return Form(
      key: form.key,
      child: Column(
        children: [
          CustomTextField(
            autoValidateMode: AutovalidateMode.onUserInteraction,
            focusNode: form.nodes[0],
            textEditingController: form.controllers[0],
            labelText: AppLocalization.of(context).translate("group_name"),
          ),
          SizedBox(height: 20.h),
          CustomTextField(
            autoValidateMode: AutovalidateMode.onUserInteraction,
            focusNode: form.nodes[1],
            textEditingController: form.controllers[1],
            labelText: AppLocalization.of(context).translate("media_name"),
          ),
          SizedBox(height: 50.h),
          CustomButton(
            width: 1.sw,
            backgroundColor: AppColors.primaryColor,
            borderRadius: 10.r,
            buttonName: AppLocalization.of(context).translate("edit"),
          ),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  @override
  int numberOfFields() => 2;
}
