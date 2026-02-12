import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/firebase_api.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/forget_password_usecase.dart';
import 'package:centro_partner/features/auth/ui/reset_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ForgetPasswordSheet extends StatefulWidget {

  const ForgetPasswordSheet({super.key});

  @override
  State<ForgetPasswordSheet> createState() => _ForgetPasswordSheetState();
}

class _ForgetPasswordSheetState extends State<ForgetPasswordSheet>  with FormStateMinxin {

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
              prefixIcon: Icons.phone_android_outlined,
              keyboardType: TextInputType.number,
              validator: (value) {
                return BaseValidator.validateValue(
                  context,
                  form.controllers[0].text,
                  [RequiredValidator(),PhoneNumberValidator(value: value)],
                );
              },
              focusNode: form.nodes[0],
              textEditingController: form.controllers[0],
              labelText: AppLocalization.of(context).translate("phone"),
            ),
            SizedBox(height: 50.h),
            CreateModel(
                onSuccess: (model) async {
                  Navigation.popThenPush(ResetPasswordScreen(phone: form.controllers[0].text));
                },
                withValidation: true,
                onTap: () {
                  return form.validate();
                },
                useCaseCallBack: (model) {
                  return ForgetPasswordUseCase(AuthRepository()).call(
                      params: ForgetPasswordParams(
                        phone: form.controllers[0].text,
                        firebaseToken: FirebaseApi.deviceToken.toString()
                      ));
                },
                child: CustomButton(
                  width: 1.sw,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 10.r,
                  buttonName: AppLocalization.of(context).translate("send"),
                ),
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  @override
  int numberOfFields() => 1;
}
