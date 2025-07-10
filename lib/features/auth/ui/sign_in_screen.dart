import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/clasess/app_storage.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/errors/unauthorized_error.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/login_model.dart';
import 'package:centro_partner/features/auth/data/usecase/login_usecase.dart';
import 'package:centro_partner/features/auth/ui/sign_up_screen.dart';
import 'package:centro_partner/features/auth/ui/verification_code_screen.dart';
import 'package:centro_partner/features/auth/widgets/forget_password_sheet.dart';
import 'package:centro_partner/features/nav_bar/ui/nav_bar_screen.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
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

  SignInScreen({super.key});

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
                Image.asset(logo,width: 200.w,height: 120.h),
                SizedBox(height: 15.h),
                Text(AppLocalization.of(context).translate("sign_in").toUpperCase(),
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
                      [RequiredValidator()],
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
                              style: AppTheme.bodyMedium,
                            ),
                            padding: 30.w,
                            context: context,
                            child: ForgetPasswordSheet()
                        );
                      },
                      child: Text("${AppLocalization.of(context).translate("forget_password")}?",
                          style: AppTheme.labelMedium.copyWith(color: AppColors.primaryColor)
                      ),
                    ),
                  ],
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
                        textStyle: AppTheme.titleSmall.copyWith(color: AppColors.primaryColor),
                        buttonName: AppLocalization.of(context).translate("sign_up"),
                        function: () => Navigation.pushReplacement(SignUpScreen()),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: CreateModel(
                        withValidation: true,
                        onSuccess: (LoginModel model) async {
                          await saveLoginTokens(model.token!);
                          AppStorage.saveData(key: userID, value: model.user!.id);
                          AppStorage.saveData(key: accountType, value: model.user!.role);
                          AppStorage.saveData(key: isFillInfo, value: model.user!.isFilled);
                          if(model.user!.role == "court" && model.user!.isFilled == 0) {
                            // todo go to fill info of court
                          } else if(model.user!.role != "court" && model.user!.isFilled == 0) {
                            // todo go to fill info of trainer
                          } else {
                            if(model.user!.role != "court") {
                              // todo check info of court
                            } else {
                              // todo check info of trainer
                            }
                          }
                        },
                        onError: (String errorMessage) {
                          if (errorMessage == UnauthorizedError(message: errorMessage).message) {
                            Navigation.push(VerificationCodeScreen(phoneNumber: form.controllers[0].text));
                          } else {
                            Dialogs.showQuestion(context, title: errorMessage);
                          }
                        },
                        onTap: () {
                          return form.validate();
                        },
                        useCaseCallBack: (model) => LoginUseCase(AuthRepository()).call(
                            params: LoginParams(
                              phone: form.controllers[0].text,
                              password: form.controllers[1].text,
                            )),
                        child: CustomButton(
                          width: 1.sw,
                          backgroundColor: AppColors.primaryColor,
                          borderRadius: 10.r,
                          buttonName: AppLocalization.of(context).translate("sign_in"),
                          // todo remove later
                          function: () => Navigation.pushReplacement(NavBarScreen(pageIndex: 1)),
                        ),
                      )
                    ),
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
  int numberOfFields() => 2;
}
