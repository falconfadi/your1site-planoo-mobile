import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/court/court_create_activity_screen.dart';
import 'package:centro_partner/features/home/widget/court/activity/court_activity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourtActivitiesTab extends StatelessWidget {

  const CourtActivitiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
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
                function: () => Navigation.push(CourtCreateActivityScreen()),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context,index) {
              return Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: CourtActivityWidget()
              );
            },
          )
        ],
      ),
    );
  }
}
