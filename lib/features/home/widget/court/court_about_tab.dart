import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/home/ui/court/create_court_screen.dart';
import 'package:centro_partner/features/home/ui/create_location_screen.dart';
import 'package:centro_partner/features/home/widget/view_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CourtAboutTab extends StatefulWidget {

  const CourtAboutTab({super.key});

  @override
  State<CourtAboutTab> createState() => _CourtAboutTabState();
}

class _CourtAboutTabState extends State<CourtAboutTab> {


  @override
  void initState() {
    super.initState();
    /// enable it if the location is empty
    // Dialogs.showQuestion(context,
    //   title: "",content: Column(
    //     children: [
    //       Text(AppLocalization.of(context).translate("you_must_add_your_location_first"),
    //         textAlign: TextAlign.center,
    //         style: AppTheme.titleSmall.copyWith(color: AppColors.mediumGrayColor),
    //       ),
    //     ],
    //   ),
    //   btnOk: CustomButton(
    //     height: 40.h,
    //     width: 1.sw,
    //     backgroundColor: AppColors.whiteColor,
    //     borderRadius: 8.r,
    //     buttonName: AppLocalization.of(context).translate("add"),
    //     textStyle: AppTheme.titleSmall.copyWith(fontSize: 15, color: AppColors.blackColor),
    //     // function: () => Navigation.push(CreateLocationScreen()),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    ViewImageWidget(
                        image: "",
                        width: 80.w,
                        height: 80.w,
                        borderRadius: 20.r,
                    ),
                    SizedBox(width: 10.h),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Court name",style: AppTheme.labelMedium),
                          CustomTextsWidget(title: "09987455587",titleStyle: AppTheme.labelMedium),
                          Text(AppLocalization.of(context).translate("outdoor"),
                            style: AppTheme.labelMedium,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 30.w,
                child: PopupMenuButton(
                  offset: const Offset(0,30),
                  onSelected: (value) {},
                  color: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  elevation: 10,
                  shadowColor: AppColors.gray2Color,
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                        value: "",
                        height: 50.h,
                        child: Center(
                          child: Text(
                            AppLocalization.of(context).translate("edit"),
                            style: AppTheme.labelSmall,
                          ),
                        ),
                        onTap: () => Navigation.push(CreateCourtScreen(isEdit: true))
                    ),
                    PopupMenuItem(
                      value: "",
                      height: 50.h,
                      child: Center(
                        child: Text(
                          AppLocalization.of(context).translate("activate"),
                          // AppLocalization.of(context).translate("deactivate"),
                          style: AppTheme.labelSmall,
                        ),
                      ),
                      onTap: () {
                        // todo activate or deactivate
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CustomTextsWidget(title: "${AppLocalization.of(context).translate("type")}:", text: "Football"),
          SizedBox(height: 10.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text("location name",style: AppTheme.labelMedium),
              ),
              SizedBox(width: 10.w),
              SizedBox(
                width: 30.w,
                child: PopupMenuButton(
                  offset: const Offset(0,30),
                  onSelected: (value) {},
                  color: AppColors.whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.r)),
                  ),
                  elevation: 10,
                  shadowColor: AppColors.gray2Color,
                  itemBuilder: (BuildContext context) => [
                    PopupMenuItem(
                        value: "",
                        height: 50.h,
                        child: Center(
                          child: Text(
                            AppLocalization.of(context).translate("edit"),
                            style: AppTheme.labelSmall,
                          ),
                        ),
                        onTap: () => Navigation.push(CreateLocationScreen(isEdit: true))
                    ),
                    PopupMenuItem(
                        value: "",
                        height: 50.h,
                        child: Center(
                          child: Text(
                            AppLocalization.of(context).translate("delete"),
                            style: AppTheme.labelSmall.copyWith(color: AppColors.redColor),
                          ),
                        ),
                        onTap: () {
                          Dialogs.showQuestion(context,
                            title: "",content: Column(
                              children: [
                                ListTile(
                                  title: Text("${AppLocalization.of(context).translate("are_you_sure")}?",textAlign: TextAlign.center,
                                    style: AppTheme.titleSmall.copyWith(color: AppColors.mediumGrayColor),
                                  ),
                                ),
                              ],
                            ),
                            btnOk: CustomButton(
                              height: 40.h,
                              width: 1.sw,
                              backgroundColor: AppColors.whiteColor,
                              borderRadius: 8.r,
                              buttonName: AppLocalization.of(context).translate("ok"),
                              textStyle: AppTheme.titleSmall.copyWith(fontSize: 15, color: AppColors.blackColor),
                            ),
                          );
                        }
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          CustomTextsWidget(title: "${AppLocalization.of(context).translate("description")}:",text: null),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 10.h),
            child: Text("Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc",
              style: AppTheme.labelMedium,
            ),
          ),
        ],
      ),
    );
  }
}
