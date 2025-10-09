import 'dart:io';
import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/boilerplate/get_model/cubits/get_model_cubit.dart';
import 'package:centro_partner/core/boilerplate/get_model/widgets/get_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/features/auth/data/model/login_model.dart';
import 'package:centro_partner/features/home/widget/view_image_widget.dart';
import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import 'package:centro_partner/features/profile/data/usecase/delete_profile_image_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/get_user_usecase.dart';
import 'package:centro_partner/features/profile/widget/edit_profile_sheet.dart';
import 'package:centro_partner/features/profile/widget/pick_image_sheet.dart';
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
  GetModelCubit<LoginModel>? _userCubit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: AppLocalization.of(context).translate("profile"), isNavBar: true),
      body: GetModel<LoginModel>(
          onCubitCreated: (cubit) {
            _userCubit = cubit as GetModelCubit<LoginModel>;
          },
          useCaseCallBack: () {
            return GetUserUseCase(ProfileRepository()).call(params: GetUserParams());
            },
          onSuccess: (model) {},
          withAnimation: false,
          modelBuilder: (model) => SingleChildScrollView(
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
                          image: model.user!.profileImage == null ? "" : model.user!.profileImage!.url!.toString(),
                          width: 100.w,
                          height: 100.w,
                          borderRadius: 10.r,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            CustomSheet.show(
                              isDismissible: true,
                              header: Text(AppLocalization.of(context).translate("select_image"),
                                style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                              ),
                              action: model.user!.profileImage == null ? null : CreateModel(
                                withValidation: false,
                                loadingHeight: 20.h,
                                onTap: () {},
                                onSuccess: (model) {
                                  Navigator.pop(context);
                                  _userCubit?.getModel();
                                },
                                useCaseCallBack: (model) => DeleteProfileImageUseCase(ProfileRepository()).call(
                                    params: DeleteProfileImageParams()),
                                child: SvgPicture.asset(delete,width: 25.w),
                              ),
                              padding: 30.w,
                              context: context,
                              child: PickImageSheet(onImageUpdated: () async {
                                _userCubit?.getModel();
                              }),
                            );
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
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                ProfileCard(title: "name",subtitle: model.user!.name!),
                SizedBox(height: 15.h),
                ProfileCard(title: "phone",subtitle: model.user!.phone!),
                SizedBox(height: 20.h),
                ProfileCard(title: "email_address",subtitle: model.user!.email!),
                SizedBox(height: 15.h),
                Card(
                  color: AppColors.whiteColor,
                  elevation: 3,
                  shadowColor: AppColors.gray2Color,
                  child: Container(
                    width: 1.sw,
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
                          text: model.user!.description!,
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
                                child: EditProfileSheet(model: model,onImageUpdated: () async {
                                  _userCubit?.getModel();
                                })
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
      )
    );
  }
}
