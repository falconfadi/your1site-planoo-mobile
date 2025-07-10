import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/enum/account_type.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/utils/validators/email_validator.dart';
import 'package:centro_partner/core/utils/validators/password_validator.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/register_usecase.dart';
import 'package:centro_partner/features/auth/ui/verification_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';

class SignUpScreen extends StatefulWidget {

  SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>  with FormStateMinxin {

  AccountType? selectAccountType;
  bool acceptTerms = true;

  void toggleTerms() {
    acceptTerms = !acceptTerms;
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.scaffoldColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Form(
              key: form.key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30.h),
                  Image.asset(logo,width: 200.w,height: 120.h),
                  SizedBox(height: 15.h),
                  Text(AppLocalization.of(context).translate("sign_up").toUpperCase(),
                      style: AppTheme.titleMedium.copyWith(fontSize: 25)),
                  SizedBox(height: 30.h),
                  CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    prefixIcon: Icons.phone,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator(),PhoneNumberValidator()],
                      );
                    },
                    focusNode: form.nodes[0],
                    nextFocusNode: form.nodes[1],
                    textEditingController: form.controllers[0],
                    labelText: AppLocalization.of(context).translate("phone"),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    prefixIcon: Icons.email_outlined,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator(),EmailValidator()],
                      );
                    },
                    focusNode: form.nodes[1],
                    nextFocusNode: form.nodes[2],
                    textEditingController: form.controllers[1],
                    labelText: AppLocalization.of(context).translate("email_address"),
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
                        [RequiredValidator(),PasswordValidator(value: value)],
                      );
                    },
                    focusNode: form.nodes[2],
                    textEditingController: form.controllers[2],
                    labelText: AppLocalization.of(context).translate("password"),
                  ),
                  SizedBox(height: 20.h),
                  CustomDropDown(
                    width: 1.sw,
                    height: 56.h,
                    text: AppLocalization.of(context).translate("account_type"),
                    value: selectAccountType,
                    onChanged: (newValue) {
                      setState(() {
                        selectAccountType = newValue as AccountType?;
                      });
                    },
                    items: AccountType.values.map((AccountType value) {
                      return DropdownMenuItem<AccountType>(
                        value: value,
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            Text(AppLocalization.of(context).translate(value.name), style: AppTheme.labelMedium),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          width: 1.sw,
                          backgroundColor: Colors.transparent,
                          borderSideColor: Colors.transparent,
                          borderRadius: 10.r,
                          buttonName: AppLocalization.of(context).translate("sign_in"),
                          textStyle: AppTheme.titleSmall.copyWith(color: AppColors.primaryColor),
                          function: () => Navigation.pushReplacement(SignInScreen()),
                        ),
                      ),
                      SizedBox(width: 15.w),
                      Expanded(
                        child: CreateModel(
                          onSuccess: (result) async {
                            Navigation.push(VerificationCodeScreen(phoneNumber: form.controllers[0].text));
                          },
                          withValidation: true,
                          onTap: () {
                            bool isValid = form.validate();
                            if (selectAccountType == null) {
                              Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("account_type_required"));
                              return false; // Prevent API call
                            }
                            return isValid;
                          },
                          useCaseCallBack: ( model) {
                            return RegisterUseCase(AuthRepository()).call(
                                params: RegisterParams(
                                    phone: form.controllers[0].text,
                                    email: form.controllers[1].text,
                                    password: form.controllers[2].text,
                                    confirmationPassword: form.controllers[2].text,
                                    type: selectAccountType!.name,
                                    // firebaseToken: FirebaseApi.deviceToken.toString() // todo enable it later
                                ));
                          },
                          child: CustomButton(
                            width: 1.sw,
                            backgroundColor: AppColors.primaryColor,
                            borderSideColor: AppColors.primaryColor,
                            borderRadius: 10.r,
                            buttonName: AppLocalization.of(context).translate("sign_up"),
                            // todo remove later
                            function: () => Navigation.push(VerificationCodeScreen(phoneNumber: form.controllers[0].text)),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        )
    );
  }

  @override
  int numberOfFields() => 3;
}
