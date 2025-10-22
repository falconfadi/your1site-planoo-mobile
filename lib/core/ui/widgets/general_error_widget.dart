import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import '../../errors/error_helper.dart';
import '../../errors/bad_request_error.dart';
import '../../errors/not_found_error.dart';
import '../../errors/unauthorized_error.dart';
import '../../errors/forbidden_error.dart';
import '../../errors/internal_server_error.dart';
import '../../errors/net_error.dart';
import '../../errors/socket_error.dart';
import '../../errors/timeout_error.dart';

class GeneralErrorWidget extends StatelessWidget {

  final dynamic error;
  final VoidCallback? onTap;
  final String? message;
  final String? buttonText;
  final Widget? body;

  const GeneralErrorWidget({
    super.key,
    this.error,
    this.onTap,
    this.message,
    this.buttonText,
    this.body,
  });

  bool get _showRetryButton {
    return error is InternalServerError ||
        error is TimeoutError ||
        error is NetError ||
        error is SocketError ||
        error is BadRequestError;
  }

  Widget _buildErrorBody() {
    if (error is UnauthorizedError) {
      return const Center(
        child: Icon(Icons.lock_outline),
      );
    }
    if (error is NotFoundError) {
      return const Center(
        child: Icon(Icons.search_off),
      );
    }
    if (error is ForbiddenError) {
      return const Center(
        child: Icon(Icons.block),
      );
    }
    return body ??
        const Center(
          child: Icon(Icons.error_outline),
        );
  }

  @override
  Widget build(BuildContext context) {
    final errorHelper = ErrorHelper();
    final errorMessage = message ?? errorHelper.getErrorMessage(error);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 5.h),
          _buildErrorBody(),
          SizedBox(height: 5.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              errorMessage,
              style: AppTheme.labelSmall.copyWith(fontSize: 11.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          if (_showRetryButton)
            Container(
              width: 1.sw * 0.4,
              padding: EdgeInsets.only(top: 5.h),
              child: CustomButton(
                height: 40.h,
                function: onTap,
                buttonName: buttonText ?? AppLocalization.of(context).translate("try_again"),
                backgroundColor: AppColors.lightPurpleColor,
                borderRadius: 0,
                textStyle: AppTheme.titleLarge.copyWith(color: AppColors.whiteColor),
              ),
            ),
        ],
      ),
    );
  }
}
