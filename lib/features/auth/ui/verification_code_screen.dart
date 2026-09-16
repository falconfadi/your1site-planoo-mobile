import 'dart:async';
import 'dart:convert';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/model/country_code_model.dart';
import 'package:centro_partner/features/auth/data/usecase/resend_code_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/verify_code_usecase.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:centro_partner/features/auth/widgets/footer_widget.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

class VerificationCodeScreen extends StatefulWidget {

  final String phoneNumber;
  final String countryDialCode;
  final String selectedIsoCode;
  final bool fromSingUp;

  const VerificationCodeScreen({super.key,
    required this.phoneNumber,
    required this.countryDialCode,
    required this.selectedIsoCode,
    this.fromSingUp = true
  });

  @override
  State<VerificationCodeScreen> createState() => _VerificationCodeScreenState();
}

class _VerificationCodeScreenState extends State<VerificationCodeScreen> {

  static PinTheme defaultPinTheme = PinTheme(
    width: 50.w,
    height: 80.h,
    textStyle: AppTheme.headlineMedium,
    decoration: BoxDecoration(
      color: AppColors.whiteColor,
      border: Border.all(color: AppColors.blackColor),
      borderRadius: BorderRadius.circular(8.r),
    ),
  );
  static PinTheme focusedPinTheme = defaultPinTheme.copyDecorationWith(
    color: AppColors.whiteColor,
    border: Border.all(color: AppColors.blackColor),
    borderRadius: BorderRadius.circular(8.r),
  );
  static PinTheme submittedPinTheme = defaultPinTheme.copyWith(
    decoration: defaultPinTheme.decoration?.copyWith(
      color: AppColors.whiteColor,
    ),
  );

  late TextEditingController codeController;
  Timer? timer;
  int _seconds = 60;
  bool enableResend = false;

  @override
  void initState() {
    super.initState();
    codeController = TextEditingController();

    if(!widget.fromSingUp) {
      _seconds=0;
    }
    _startTimer();
  }

  void _resendCode() {
    setState((){
      _seconds = 60;
      enableResend = false;
    });
    _startTimer();
  }

  void _startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(_seconds != 0){
        setState(() {
          _seconds = _seconds - 1;
        });
      }
      else {
        setState(() {
          enableResend = true;
          timer.cancel();
        });
      }
    });
  }

  @override
  void dispose() {
    codeController.dispose();
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.scaffoldColor,
      appBar: widget.fromSingUp ? null : AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: widget.fromSingUp ? 30.h : 0),
              Image.asset(logo,width: 1.sw,height: 90.h),
              SizedBox(height: 40.h),
              RichText(
                text: TextSpan(
                  text: "${AppLocalization.of(context).translate("we_sent_you_code")} ",
                  style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
                  children: [
                    TextSpan(
                      text: " ",
                    ),
                    TextSpan(
                      text: widget.countryDialCode + widget.phoneNumber,
                      style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Pinput(
                length: 6,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                controller: codeController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
              ),
              SizedBox(height: 50.h),
              CreateModel(
                withValidation: false,
                onTap: () {},
                onSuccess: (data) async {
                  await AppStorage.saveData(
                    key: countryCodeKey,
                    value: jsonEncode(
                      CountryCodeModel(
                        isoCode: widget.selectedIsoCode,
                        dialCode: widget.countryDialCode,
                      ).toJson(),
                    ),
                  );

                  if (context.mounted) {
                    Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("account_verified"));
                    Navigation.pushAndRemoveUntil(SignInScreen());
                  }
                },
                useCaseCallBack: (model) {
                  return VerifyCodeUseCase(AuthRepository()).call(
                      params: VerifyCodeParams(
                          phone: widget.phoneNumber,
                          countryCode: widget.countryDialCode,
                          code: codeController.text
                      ));
                },
                child: CustomButton(
                  width: 1.sw,
                  backgroundColor: AppColors.primaryColor,
                  borderSideColor: AppColors.primaryColor,
                  borderRadius: 10.r,
                  buttonName: AppLocalization.of(context).translate("verify"),
                ),
              ),
              SizedBox(height: 80.h),
              enableResend ? CreateModel(
                withValidation: false,
                onSuccess: (result) {
                  _resendCode();
                },
                useCaseCallBack: (data) {
                  codeController.clear();
                  return ResendCodeUseCase(AuthRepository()).call(
                      params: ResendCodeParams(
                          phone: widget.phoneNumber,
                          countryCode: widget.countryDialCode
                      )
                  );
                },
                child: FooterWidget(
                  text: AppLocalization.of(context).translate("did_not_receive_code"),
                  link: AppLocalization.of(context).translate("resend"),
                ),
              ) : FooterWidget(
                text: AppLocalization.of(context).translate("did_not_receive_code"),
                link: _seconds > 0 ? ' ($_seconds)' : '',
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      )
    );
  }
}
