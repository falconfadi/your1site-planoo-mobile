import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/match_validator.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/change_password_usecase.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/password_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChangePasswordScreen extends StatefulWidget {

  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen>  with FormStateMinxin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: AppLocalization.of(context).translate("change_password"),isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: form.key,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              CustomTextField(
                isPassword: true,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                prefixIcon: Icons.lock,
                validator: (value) {
                  return BaseValidator.validateValue(
                    context,
                    form.controllers[0].text,
                    [RequiredValidator(),PasswordValidator(value: value)],
                  );
                },
                focusNode: form.nodes[0],
                nextFocusNode: form.nodes[1],
                textEditingController: form.controllers[0],
                labelText: AppLocalization.of(context).translate("old_password"),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                isPassword: true,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                prefixIcon: Icons.lock,
                validator: (value) {
                  return BaseValidator.validateValue(
                    context,
                    form.controllers[1].text,
                    [ RequiredValidator(),PasswordValidator(value: value)],
                  );
                },
                focusNode: form.nodes[1],
                nextFocusNode: form.nodes[2],
                textEditingController: form.controllers[1],
                labelText: AppLocalization.of(context).translate("new_password"),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                isPassword: true,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                prefixIcon: Icons.lock,
                validator: (value) {
                  return BaseValidator.validateValue(
                    context,
                    form.controllers[2].text,
                    [ RequiredValidator(),MatchValidator(value: form.controllers[1].text)],
                  );
                },
                focusNode: form.nodes[2],
                textEditingController: form.controllers[2],
                labelText: AppLocalization.of(context).translate("confirm_password"),
              ),
              SizedBox(height: 50.h),
              CreateModel(
                onSuccess: (result) async {
                  Navigation.pop();
                  Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("password_changed_successfully"));
                },
                withValidation: true,
                onTap: () {
                  return form.validate();
                },
                useCaseCallBack: (model) {
                  return ChangePasswordUseCase(AuthRepository()).call(
                      params: ChangePasswordParams(
                        oldPassword: form.controllers[0].text,
                        newPassword: form.controllers[1].text,
                        confirmationPassword: form.controllers[2].text,
                      ));
                },
                child: CustomButton(
                  width: 1.sw,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 10.r,
                  buttonName: AppLocalization.of(context).translate("save"),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      )
    );
  }

  @override
  int numberOfFields() => 3;
}
