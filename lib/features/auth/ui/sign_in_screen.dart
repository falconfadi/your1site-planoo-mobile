import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/sign_in_model.dart';
import 'package:centro_partner/features/auth/data/usecase/sign_in_usecase.dart';
import 'package:centro_partner/features/auth/ui/sign_up_screen.dart';
import 'package:centro_partner/features/auth/ui/verification_code_screen.dart';
import 'package:centro_partner/features/auth/widgets/footer_widget.dart';
import 'package:centro_partner/features/auth/widgets/forget_password_sheet.dart';
import 'package:centro_partner/features/general/ui/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/password_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class SignInScreen extends StatefulWidget {

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>  with FormStateMinxin {

  Future<void> saveLoginTokens(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int expirationTimestamp = decodedToken['exp']; // in seconds since epoch
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);

    await AppStorage.saveData(key: kAccessToken, value: token);
    await AppStorage.saveData(key: kAccessTokenExpirationDate, value: expirationDate.toIso8601String());
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
                Image.asset(logo,width: 1.sw,height: 90.h),
                Text(AppLocalization.of(context).translate("sign_in").toUpperCase(),
                    style: AppTheme.headlineSmall.copyWith(fontSize: 26.sp)),
                SizedBox(height: 40.h),
                CustomTextField(
                  autoFocus: false,
                  autoValidateMode: AutovalidateMode.onUserInteraction,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_android_outlined,
                  validator: (value) {
                    return BaseValidator.validateValue(
                      context,
                      value!,
                      [RequiredValidator(),PhoneNumberValidator(value: value)],
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
                  focusNode: form.nodes[1],
                  textEditingController: form.controllers[1],
                  labelText: AppLocalization.of(context).translate("password"),
                ),
                SizedBox(height: 10.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () {
                        CustomSheet.show(
                            isDismissible: true,
                            header: Text(AppLocalization.of(context).translate("forget_password"),
                              style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                            ),
                            padding: 30.w,
                            context: context,
                            child: ForgetPasswordSheet()
                        );
                      },
                      child: Text(AppLocalization.of(context).translate("forget_password") +
                          AppLocalization.of(context).translate("?"),
                          style: AppTheme.bodyLarge.copyWith(color: AppColors.primaryColor)
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50.h),
                CreateModel(
                  withValidation: true,
                  onSuccess: (SignInModel model) async {
                    await saveLoginTokens(model.token!);
                    AppStorage.saveData(key: userID, value: model.user!.id);
                    AppStorage.saveData(key: userType, value: model.user!.accountType);
                    Navigation.pushAndRemoveUntil(NavBarScreen(pageIndex: 0));
                  },
                  onTap: () {
                    return form.validate();
                  },
                  onError: (String errorMessage) {
                    if (errorMessage.toLowerCase().contains("unverified account")) {
                      Navigation.push(VerificationCodeScreen(phoneNumber: form.controllers[0].text,fromSingUp: false));
                    } else {
                      Dialogs.showQuestion(context, title: errorMessage);
                    }
                  },
                  useCaseCallBack: (model) => SignInUseCase(AuthRepository()).call(
                      params: SignInParams(
                        phone: form.controllers[0].text,
                        password: form.controllers[1].text,
                      )),
                  child: CustomButton(
                    backgroundColor: AppColors.primaryColor,
                    borderRadius: 10.r,
                    buttonName: AppLocalization.of(context).translate("sign_in"),
                  ),
                ),
                SizedBox(height: 80.h),
                FooterWidget(
                    text: AppLocalization.of(context).translate("do_not_have_account") + AppLocalization.of(context).translate("?"),
                    link: AppLocalization.of(context).translate("sign_up"),
                    linkTap: () => Navigation.pushReplacement(SignUpScreen())),
                SizedBox(height: 50.h),
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