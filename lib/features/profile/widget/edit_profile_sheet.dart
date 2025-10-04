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

class EditProfileSheet extends StatefulWidget {


  const EditProfileSheet({super.key});

  @override
  State<EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<EditProfileSheet>   with FormStateMinxin {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Form(
        key: form.key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
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
              validator: (value) {
                return BaseValidator.validateValue(
                  context,
                  value!,
                  [RequiredValidator()],
                );
              },
              focusNode: form.nodes[1],
              textEditingController: form.controllers[1],
              labelText: AppLocalization.of(context).translate("description"),
            ),
            SizedBox(height: 30.h),
            CustomButton(
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              borderRadius: 10.r,
              buttonName: AppLocalization.of(context).translate("save"),
              function: () {
                // todo edit profile api
              },
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

