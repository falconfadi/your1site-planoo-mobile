import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/match_validator.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/reset_password_usecase.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/password_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResetPasswordScreen extends StatefulWidget {

  String phone;

  ResetPasswordScreen({required this.phone,super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen>  with FormStateMinxin {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Form(
            key: form.key,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(logo,width: 200.w,height: 120.h),
                SizedBox(height: 30.h),
                CustomTextField(
                  autoFocus: false,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return BaseValidator.validateValue(
                      context,
                      value!,
                      [RequiredValidator(),PasswordValidator(value: value)],
                    );
                  },
                  focusNode: form.nodes[0],
                  nextFocusNode: form.nodes[1],
                  textEditingController: form.controllers[0],
                  labelText: AppLocalization.of(context).translate("new_password"),
                ),
                SizedBox(height: 20.h),
                CustomTextField(
                  autoFocus: false,
                  isPassword: true,
                  prefixIcon: Icons.lock,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    return BaseValidator.validateValue(
                      context,
                      value!,
                      [RequiredValidator(),MatchValidator(value: form.controllers[0].text),],
                    );
                  },
                  focusNode: form.nodes[1],
                  textEditingController: form.controllers[1],
                  labelText: AppLocalization.of(context).translate("confirm_password"),
                ),
                SizedBox(height: 50.h),
                CreateModel(
                  onSuccess: (result) async {
                    Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("password_reseted"));
                    Navigation.pushReplacement(SignInScreen());
                  },
                  withValidation: true,
                  onTap: () {
                    return form.validate();
                  },
                  useCaseCallBack: (model) {
                    return ResetPasswordUseCase(AuthRepository()).call(
                        params: ResetPasswordParams(
                          phone: widget.phone,
                          password: form.controllers[0].text,
                          confirmationPassword: form.controllers[1].text,
                        ));
                  },
                  child: CustomButton(
                    width: 1.sw,
                    backgroundColor: AppColors.primaryColor,
                    borderSideColor: AppColors.primaryColor,
                    borderRadius: 10.r,
                    buttonName: AppLocalization.of(context).translate("reset"),
                    // todo remove later
                    function: () {
                      Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("password_reseted"));
                      Navigation.pushReplacement(SignInScreen());
                    },
                  ),
                ),
                SizedBox(height: 30.h),
              ],
            ),
          ),
        ),
      )
    );
  }

  @override
  int numberOfFields() => 2;
}
