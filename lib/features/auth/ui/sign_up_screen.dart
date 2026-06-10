import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/firebase_api.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/select_single_item_widget.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/core/utils/validators/email_validator.dart';
import 'package:centro_partner/core/utils/validators/password_validator.dart';
import 'package:centro_partner/core/utils/validators/phone_number_validation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/user_type_model.dart';
import 'package:centro_partner/features/auth/data/usecase/register_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/user_types_usecase.dart';
import 'package:centro_partner/features/auth/ui/verification_code_screen.dart';
import 'package:centro_partner/features/auth/widgets/footer_widget.dart';
import 'package:centro_partner/features/general/ui/terms_and_conditions_screen.dart';
import 'package:flutter/gestures.dart';
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
  bool acceptTerms = false;

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
                  SizedBox(height: 10.h),
                  Image.asset(logo,width: 1.sw,height: 90.h),
                  Text(AppLocalization.of(context).translate("sign_up").toUpperCase(),
                      style: AppTheme.headlineSmall.copyWith(fontSize: 25.sp)),
                  SizedBox(height: 40.h),
                  GetModel<UserTypeModel>(
                    useCaseCallBack: () {
                      return UserTypesUseCase(AuthRepository()).call(params: UserTypesParams());
                    },
                    modelBuilder: (model) => SelectSingleItemWidget<String, String>(
                      title: selectAccountType ?? AppLocalization.of(context).translate("account_type"),
                      titleColor: selectAccountType == null
                          ? AppColors.mediumGrayColor
                          : AppColors.blackColor,
                      list: model.userTypesList!,
                      selectedId: selectAccountType,
                      labelBuilder: (item) => item,
                      idBuilder: (item) => item,
                      onSelect: (id) {
                        setState(() {
                          selectAccountType = id;
                        });
                      },
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
                    prefixIcon: Icons.phone_android_outlined,
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
                  SizedBox(height: 20.h),
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
                                    value: acceptTerms,
                                    activeColor: AppColors.primaryColor,
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                    onChanged: (value) {
                                      setState(() {
                                        acceptTerms = value ?? false;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              SizedBox(width: isTablet ? 5.w : 0),
                              Expanded(
                                child: RichText(
                                    text: TextSpan(
                                        children: <InlineSpan>[
                                          TextSpan(
                                            text: "${AppLocalization.of(context).translate("i_agree_to")} ",
                                            style: AppTheme.bodyLarge.copyWith(fontSize: isTablet ? 15.sp : null),
                                          ),
                                          TextSpan(
                                            text: AppLocalization.of(context).translate("terms_and_conditions").toLowerCase(),
                                            style: AppTheme.bodyLarge.copyWith(fontSize: isTablet ? 15.sp : null,
                                              color: AppColors.primaryColor,fontWeight: FontWeight.bold
                                            ),
                                            recognizer: TapGestureRecognizer()..onTap = () => Navigation.push(TermsAndConditionsScreen()),
                                          ),
                                        ]
                                    )
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                  SizedBox(height: 30.h),
                  CreateModel(
                    onSuccess: (result) async {
                      Navigation.pushAndRemoveUntil(VerificationCodeScreen(phoneNumber: form.controllers[2].text));
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
                      if(acceptTerms == true) {
                        return RegisterUseCase(AuthRepository()).call(
                            params: RegisterParams(
                                name: form.controllers[0].text,
                                email: form.controllers[1].text,
                                phone: form.controllers[2].text,
                                password: form.controllers[3].text,
                                confirmationPassword: form.controllers[3].text,
                                accountType: selectAccountType,
                                description: form.controllers[4].text,
                                firebaseToken: FirebaseApi.deviceToken.toString()
                            ));
                      }
                    },
                    child: CustomButton(
                      width: 1.sw,
                      backgroundColor: acceptTerms == false ? AppColors.grayColor : AppColors.primaryColor,
                      borderSideColor: AppColors.primaryColor,
                      borderRadius: 10.r,
                      buttonName: AppLocalization.of(context).translate("sign_up"),
                    ),
                  ),
                  SizedBox(height: 80.h),
                  FooterWidget(
                      text: AppLocalization.of(context).translate("have_an_account") +
                          AppLocalization.of(context).translate("?"),
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
