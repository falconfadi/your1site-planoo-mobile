import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/appointment/data/appointment_repository/appointment_repository.dart';
import 'package:centro_partner/features/appointment/data/usecase/create_court_appointment_usecase.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentSheet extends StatefulWidget {

  CreateCourtAppointmentParams createCourtAppointmentParams;

  PaymentSheet({super.key, required this.createCourtAppointmentParams});

  @override
  State<PaymentSheet> createState() => _PaymentSheetState();
}

class _PaymentSheetState extends State<PaymentSheet>{

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: SvgPicture.asset(shamCash,width: 80.w,height: 80.h)),
            Expanded(child: Image.asset(syriatelCash,width: 70.w,height: 70.h)),
          ],
        ),
        SizedBox(height: 50.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomButton(
                width: 1.sw,
                backgroundColor: AppColors.redColor,
                borderRadius: 10.r,
                buttonName: AppLocalization.of(context).translate("cancel"),
                function: () {
                  Navigation.pop();
                  Navigation.pop();
                  Navigation.pop();
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: CreateModel(
                withValidation: true,
                useCaseCallBack: (data) {
                  return CreateCourtAppointmentUseCase(AppointmentRepository()).call(
                      params: widget.createCourtAppointmentParams);
                },
                onSuccess: (result) async {
                  Navigation.pop();
                  Navigation.pop();
                  Navigation.pop();
                  Dialogs.showSnackBar(context: context, message: AppLocalization.of(context).translate("court_booked_successfully"));
                },
                child: CustomButton(
                  width: 1.sw,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 8.r,
                  buttonName: AppLocalization.of(context).translate("book"),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30.h),
      ]
    );
  }
}
