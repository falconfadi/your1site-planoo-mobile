import 'dart:async';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/resend_code_usecase.dart';
import 'package:centro_partner/features/auth/data/usecase/verify_code_usecase.dart';
import 'package:centro_partner/features/auth/ui/reset_password_screen.dart';
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
  final int? code;
  final bool fromSingUp;

  const VerificationCodeScreen({required this.phoneNumber,this.code,this.fromSingUp = true,super.key});

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

    // todo enable later
    // FirebaseApi.verificationCodeNotifier.addListener(() {
    //   final code = FirebaseApi.verificationCodeNotifier.value;
    //   if (code != null && code.isNotEmpty) {
    //     setState(() {
    //       codeController.text = code;
    //     });
    //   }
    // });

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
    super.dispose();
    codeController.dispose();
    timer!.cancel();
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
                      text: "${widget.phoneNumber} ",
                      style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                    ),
                    // todo remove later
                    TextSpan(
                      text: "(${widget.code})",
                      style: AppTheme.titleLarge.copyWith(fontSize: 18.sp,color: AppColors.turquoiseColor),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),
              Pinput(
                length: 5,
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
                onSuccess: (data) {
                  if(!widget.fromSingUp) {
                    Navigation.push(ResetPasswordScreen(phone: widget.phoneNumber));
                  } else {
                    Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("account_verified"));
                    Navigation.pushAndRemoveUntil(SignInScreen());
                  }
                },
                useCaseCallBack: (model) {
                  return VerifyCodeUseCase(AuthRepository()).call(
                      params: VerifyCodeParams(
                          phone: widget.phoneNumber, code: codeController.text));
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
              CreateModel(
                withValidation: false,
                onSuccess: (result) {
                  _resendCode();
                },
                useCaseCallBack: (data) {
                  if (enableResend) {
                    codeController.clear();
                    return  ResendCodeUseCase(AuthRepository())
                        .call(params: ResendCodeParams(phone: widget.phoneNumber));
                  } else {
                    return null;
                  }
                },
                child: FooterWidget(
                  text: AppLocalization.of(context).translate("did_not_receive_code"),
                  link: !enableResend ?
                  _seconds > 0 ? ' ($_seconds)' : ''
                      : AppLocalization.of(context).translate("resend"),
                ),
              ),
              SizedBox(height: 50.h),
            ],
          ),
        ),
      )
    );
  }
}
