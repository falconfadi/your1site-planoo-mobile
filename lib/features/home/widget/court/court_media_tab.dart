import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/create_media_screen.dart';
import 'package:centro_partner/features/home/widget/view_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourtMediaTab extends StatelessWidget {

  const CourtMediaTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: CustomTextsWidget(title: "${AppLocalization.of(context).translate("count")}:" , text: "6")),
              CustomButton(
                icon: add,
                iconColor: AppColors.primaryColor,
                width: 10.w,
                height: 20.h,
                backgroundColor: AppColors.whiteColor,
                borderRadius: 0,
                buttonName: null,
                function: () => Navigation.push(CreateMediaScreen()),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Wrap(
            runSpacing: 0.h,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.start,
            runAlignment: WrapAlignment.start,
            spacing: 0.w,
            children: [1,2,3,4,5].map((time) {
              return ViewImageWidget(
                  image: profileHolder,
                width: 100.w,
                height: 100.w,
                borderRadius: 0,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
