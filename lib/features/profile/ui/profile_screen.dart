import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/clasess/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/widgets/coustom_sheet.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/logout_usecase.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:centro_partner/features/profile/ui/create_stadium_screen.dart';
import 'package:centro_partner/features/profile/ui/create_trainer_screen.dart';
import 'package:centro_partner/features/profile/ui/partner_details_screen.dart';
import 'package:centro_partner/features/profile/ui/terms_and_conditions_screen.dart';
import 'package:centro_partner/features/profile/widget/change_language_sheet.dart';
import 'package:centro_partner/features/profile/widget/change_password_sheet.dart';
import 'package:centro_partner/features/profile/widget/profile_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {

  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldColor,
      appBar: CustomHeader(title: "",isNavBar: false),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InkWell(
              onTap: () => Navigation.push(PartnerDetailsScreen()),
              child: Container(
                width: 1.sw,
                padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.w),
                color: AppColors.whiteColor,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primaryColor),
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: Image.asset(logo),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(AppLocalization.of(context).translate("partner_details"),
                              style: AppTheme.bodyMedium),
                          Text(AppLocalization.of(context).translate("partner_profile_information"),
                              style: AppTheme.labelSmall.copyWith(color: AppColors.mediumGrayColor)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            ProfileCard(
              onTap: () => Navigation.push(CreateStadiumScreen(isEdit: true)),
              icon: stadium,
              title: "stadium_details",
            ),
            // todo enable it when account type = trainer
            // SizedBox(height: 20.h),
            // ProfileCard(
            //   onTap: () => Navigation.push(CreateTrainerScreen(isEdit: true)),
            //   icon: trainer,
            //   title: "trainer_details",
            // ),
            SizedBox(height: 20.h),
            Column(
              children: [
                ProfileCard(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  icon: key,
                  title: "account",
                  subtitle: "manage_your_account",
                  withDropDownIcon: true,
                ),
                AnimatedContainer(
                  duration: Duration(microseconds: 400),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 10.h),
                  margin: EdgeInsets.symmetric(horizontal: 15.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: isExpanded
                      ? Column(
                    children: [
                      ProfileCard(
                        onTap: () {
                          CustomSheet.show(
                              isDismissible: true,
                              header: Text(
                                AppLocalization.of(context).translate("change_password"),
                                style: AppTheme.bodyMedium,
                              ),
                              padding: 20.w,
                              context: context,
                              child: ChangePasswordSheet());
                        },
                        icon: lock,
                        iconColor: AppColors.primaryColor,
                        title: "change_password",
                      ),
                      SizedBox(height: 10.h),
                      ProfileCard(
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
                              function: () {
                                // todo call delete account api
                              },
                            ),
                          );
                        },
                        icon: delete,
                        iconColor: AppColors.redColor,
                        title: "delete_account",
                      )
                    ],
                  )
                      : null,
                ),
              ],
            ),
            SizedBox(height: isExpanded == false ? 0 : 20.h),
            ProfileCard(
              onTap: () => CustomSheet.show(
                  isDismissible: true,
                  header: Text(AppLocalization.of(context).translate("language"),
                    style: AppTheme.bodyMedium,
                  ),
                  padding: 30.w,
                  context: context,
                  child: ChangeLanguageSheet()),
              icon: language,
              title: "language",
            ),
            SizedBox(height: 20.h),
            ProfileCard(
              onTap: () => Navigation.push(TermsAndConditionsScreen()),
              icon: termsAndCondition,
              title: "terms_conditions",
            ),
            SizedBox(height: 20.h),
            ProfileCard(
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
                  btnOk: CreateModel(
                    withValidation: false,
                    onSuccess: (data) async {
                      AppStorage.removeData(key: kAccessToken);
                      AppStorage.removeData(key: userID);
                      AppStorage.removeData(key: accountType);
                      Navigation.pushReplacement(SignInScreen());
                    },
                    onTap: () {},
                    useCaseCallBack: (data) {
                      return LogoutUseCase(AuthRepository()).call(
                          params: LogoutParams());
                    },
                    child: CustomButton(
                      height: 40.h,
                      width: 1.sw,
                      backgroundColor: AppColors.whiteColor,
                      borderRadius: 8.r,
                      buttonName: AppLocalization.of(context).translate("ok"),
                      textStyle: AppTheme.titleSmall.copyWith(fontSize: 15, color: AppColors.blackColor),
                      // todo remove later
                      function: () {
                        AppStorage.removeData(key: kAccessToken);
                        AppStorage.removeData(key: userID);
                        AppStorage.removeData(key: accountType);
                        Navigation.pushReplacement(SignInScreen());
                      },
                    ),
                  ),
                );
              },
              icon: logout,
              title: "log_out",
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }
}
