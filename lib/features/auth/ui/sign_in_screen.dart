import 'dart:convert';
import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/classes/firebase_api.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/project_utils/open_url.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/remember_me_model.dart';
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

  bool rememberMe = false;

  @override
  void initState() {
    super.initState();
    loadRememberMe();
  }

  void loadRememberMe() {

    String? data = AppStorage.getData(key: rememberMeKey);

    if (data != null) {
      final rememberModel = RememberMeModel.fromJson(jsonDecode(data));
      rememberMe = rememberModel.rememberMe;
      if (rememberMe) {
        form.controllers[0].text = rememberModel.phone;
        form.controllers[1].text = rememberModel.password;
      }
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> saveLoginTokens(String token) async {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int expirationTimestamp = decodedToken['exp'];
    DateTime expirationDate = DateTime.fromMillisecondsSinceEpoch(expirationTimestamp * 1000);

    await AppStorage.saveData(key: kAccessToken, value: token);
    await AppStorage.saveData(key: kAccessTokenExpirationDate, value: expirationDate.toIso8601String());
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
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
                Image.asset(logo,width: 1.sw,height: 100.h),
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
                    Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(bottom: isTablet ? 5.sp : 2.sp),
                              child: Transform.scale(
                                scale: isTablet ? 1.8 : 1,
                                child: Checkbox(
                                  value: rememberMe,
                                  activeColor: AppColors.primaryColor,
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(width: isTablet ? 5.w : 0),
                            Text(AppLocalization.of(context).translate("remember_me"),
                              style: AppTheme.bodyMedium.copyWith(fontSize: isTablet ? 15.sp : null),
                            ),
                          ],
                        )
                    ),
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
                    if (rememberMe) {
                      await AppStorage.saveData(
                        key: rememberMeKey,
                        value: jsonEncode(RememberMeModel(
                          phone: form.controllers[0].text,
                          password: form.controllers[1].text,
                          rememberMe: rememberMe,
                        ).toJson(),
                        ),
                      );
                    } else {
                      await AppStorage.removeData(key: rememberMeKey);
                    }
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
                          firebaseToken: FirebaseApi.deviceToken.toString()
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
                SizedBox(height: 60.h),
                RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                        children: <InlineSpan>[
                          TextSpan(
                            text: "${AppLocalization.of(context).translate("download_planoo_app")} ",
                            style: AppTheme.titleLarge,
                          ),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.only(top: isTablet ? 8.h : 10.h),
                              child: GestureDetector(
                                onTap: () {
                                  if(Platform.isIOS) {
                                    OpenUrl.launchUrls(Uri.parse("https://apps.apple.com/nl/app/planoo/id6767510401"));
                                  } else if (Platform.isAndroid) {
                                    OpenUrl.launchUrls(Uri.parse("https://play.google.com/store/apps/details?id=com.your1site.planoo&utm_source=emea_Med"));
                                  }
                                },
                                child: Text(
                                  "Planoo",
                                  style: AppTheme.headlineMedium.copyWith(
                                    color: AppColors.turquoiseColor,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]
                    )
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