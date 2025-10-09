import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/widgets/custom_drop_down.dart';
import 'package:centro_partner/core/utils/validators/email_validator.dart';
import 'package:centro_partner/core/utils/validators/password_validator.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/register_model.dart';
import 'package:centro_partner/features/auth/data/model/user_type_model.dart';
import 'package:centro_partner/features/auth/data/usecase/register_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/user_types_usecase.dart';
import 'package:centro_partner/features/auth/ui/verification_code_screen.dart';
import 'package:centro_partner/features/auth/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
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

  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>  with FormStateMinxin {

  String? selectAccountType;

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
                  SizedBox(height: 10.h),
                  Image.asset(logo,width: 1.sw,height: 90.h),
                  Text(AppLocalization.of(context).translate("sign_up").toUpperCase(),
                      style: AppTheme.headlineSmall.copyWith(fontSize: 25.sp)),
                  SizedBox(height: 40.h),
                  GetModel<UserTypeModel>(
                    useCaseCallBack: () {
                      return UserTypesUseCase(AuthRepository()).call(params: UserTypesParams());
                    },
                    withAnimation: false,
                    modelBuilder: (model) => CustomDropDown(
                      width: 1.sw,
                      height: 60.h,
                      text: AppLocalization.of(context).translate("account_type"),
                      value: selectAccountType,
                      onChanged: (newValue) {
                        setState(() {
                          selectAccountType = newValue;
                        });
                      },
                      items: model.userTypesList!.map((String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Row(
                          children: [
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                value,
                                style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                              ),
                            ),
                          ],
                        ),
                      ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  selectAccountType == null ? Center() :
                  CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return BaseValidator.validateValue(
                        context,
                        value!,
                        [RequiredValidator()],
                      );
                    },
                    focusNode: form.nodes[0],
                    nextFocusNode: form.nodes[1],
                    textEditingController: form.controllers[0],
                    labelText: AppLocalization.of(context).translate(
                        selectAccountType == null ? "name" : selectAccountType! == "stadium" ? "stadium_name" : "full_name"),
                  ),
                  SizedBox(height: selectAccountType == null ? 0 : 20.h),
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
                    focusNode: form.nodes[2],
                    nextFocusNode: form.nodes[3],
                    textEditingController: form.controllers[2],
                    labelText: AppLocalization.of(context).translate("phone"),
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
                    focusNode: form.nodes[3],
                    nextFocusNode: form.nodes[4],
                    textEditingController: form.controllers[3],
                    labelText: AppLocalization.of(context).translate("password"),
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
                    focusNode: form.nodes[4],
                    textEditingController: form.controllers[4],
                    labelText: AppLocalization.of(context).translate("description"),
                  ),
                  SizedBox(height: 50.h),
                  CreateModel(
                    onSuccess: (RegisterModel result) async {
                      Navigation.pushAndRemoveUntil(VerificationCodeScreen(
                        phoneNumber: form.controllers[2].text,
                        code: result.code,
                      ));
                    },
                    withValidation: true,
                    onTap: () {
                      bool isValid = form.validate();
                      if (selectAccountType == null) {
                        Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("account_type_required"));
                        return false;
                      }
                      return isValid;
                    },
                    useCaseCallBack: ( model) {
                      return RegisterUseCase(AuthRepository()).call(
                          params: RegisterParams(
                            name: form.controllers[0].text,
                            email: form.controllers[1].text,
                            phone: form.controllers[2].text,
                            password: form.controllers[3].text,
                            confirmationPassword: form.controllers[3].text,
                            accountType: selectAccountType,
                            description: form.controllers[4].text,
                            // todo change the firebaseToken later
                            firebaseToken: "eevJy1ckQVia9XkDF"
                            // firebaseToken: FirebaseApi.deviceToken.toString()
                          ));
                    },
                    child: CustomButton(
                      width: 1.sw,
                      backgroundColor: AppColors.primaryColor,
                      borderSideColor: AppColors.primaryColor,
                      borderRadius: 10.r,
                      buttonName: AppLocalization.of(context).translate("sign_up"),
                    ),
                  ),
                  SizedBox(height: 80.h),
                  FooterWidget(
                      text: "${AppLocalization.of(context).translate("have_an_account")}?",
                      link: AppLocalization.of(context).translate("sign_in"),
                      linkTap: () => Navigation.pushReplacement(SignInScreen())),
                  SizedBox(height: 50.h),
                ],
              ),
            ),
          ),
        )
    );
  }

  @override
  int numberOfFields() => 5;
}
