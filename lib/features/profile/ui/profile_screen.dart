import 'dart:io';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/project_utils/pick_image.dart';
import 'package:centro_partner/features/home/widget/view_image_widget.dart';
import 'package:centro_partner/features/profile/widget/edit_profile_sheet.dart';
import 'package:centro_partner/features/profile/widget/profile_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  File? photo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: CustomHeader(title: AppLocalization.of(context).translate("profile"), isNavBar: true),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30.h),
              Center(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(5.w),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(color: AppColors.mediumGrayColor)
                      ),
                      child: ViewImageWidget(
                        image: "https://smithhousestrategy.com/wp-content/uploads/2024/02/sports.jpg",
                        width: 100.w,
                        height: 100.w,
                        borderRadius: 10.r,
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0.w,
                      child: InkWell(
                          onTap: () async {
                            await PickImage.selectImage(image: photo);
                          },
                          child: Container(
                            width: 35.w,
                            height: 35.w,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7.r),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: AppColors.turquoiseColor,
                              ),
                              child: Center(
                                child: SvgPicture.asset(image),
                              ),
                            ),
                          )
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              ProfileCard(title: "name",subtitle: "maya"),
              SizedBox(height: 15.h),
              ProfileCard(title: "phone",subtitle: "098744552"),
              SizedBox(height: 20.h),
              ProfileCard(title: "email_address",subtitle: "maya@gmail.com"),
              SizedBox(height: 15.h),
              Card(
                color: AppColors.whiteColor,
                elevation: 3,
                shadowColor: AppColors.gray2Color,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 10.h,horizontal: 20.w),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalization.of(context).translate("description"),style: AppTheme.labelLarge.copyWith(fontSize: 20.sp)),
                      SizedBox(height: 5.w),
                      ExpandableTextWidget(
                          text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                          style: AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor,fontSize: 18.sp)
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 15.h),
              Row(
                  children: [
                    Expanded(flex: 1,child: Center()),
                    Expanded(
                      child: CustomButton(
                        height: 40.h,
                        backgroundColor: AppColors.turquoiseColor,
                        borderRadius: 10.r,
                        buttonName: AppLocalization.of(context).translate("edit_profile"),
                        function: () {
                          CustomSheet.show(
                              isDismissible: true,
                              header: Text(AppLocalization.of(context).translate("edit_profile"),
                                style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                              ),
                              padding: 30.w,
                              context: context,
                              child: EditProfileSheet()
                          );
                        },
                      ),
                    ),
                  ]
              ),
              SizedBox(height: 30.h),
            ],
          ),
        )
    );
  }
}
