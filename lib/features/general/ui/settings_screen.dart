import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_switch_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_sheet.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:centro_partner/features/general/ui/change_password_screen.dart';
import 'package:centro_partner/features/general/widget/language_sheet.dart';
import 'package:centro_partner/features/general/widget/settings_widget.dart';
import 'package:centro_partner/features/profile/data/profile_repository/profile_repository.dart';
import 'package:centro_partner/features/profile/data/usecase/delete_user_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/get_user_usecase.dart';
import 'package:centro_partner/features/profile/data/usecase/toggle_user_notification_usecase.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatefulWidget {

  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  bool notification = false;

  @override
  void initState() {
    super.initState();
    getUser();
  }

  Future getUser() async {
    final result = await GetUserUseCase(ProfileRepository()).call(
        params: GetUserParams()
    );
    if(result.hasDataOnly) {
      setState(() {
        notification = result.data!.user!.isNotifiable!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(title: AppLocalization.of(context).translate("settings"),isNavBar: false),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w,vertical: 30.h),
        child: Column(
          children: [
            SettingsWidget(
              onTap: null,
              icon: "",
              title: "notifications",
              trailing: CreateModel(
                withValidation: false,
                onTap: () => true,
                onSuccess: (model) async {
                  getUser();
                },
                useCaseCallBack: (model) {
                  return ToggleUserNotificationUseCase(ProfileRepository()).call(
                    params: ToggleUserNotificationParams(),
                  );
                },
                child: AbsorbPointer(
                  child: CustomSwitchWidget(
                    activate: notification,
                  ),
                ),
              ),
            ),
            SizedBox(height: 25.h),
            SettingsWidget(
              onTap: () => CustomSheet.show(
                  isDismissible: true,
                  header: Text(AppLocalization.of(context).translate("app_language"),
                    style: AppTheme.titleLarge.copyWith(fontSize: 18.sp),
                  ),
                  padding: 30.w,
                  context: context,
                  child: LanguageSheet()),
              icon: language,
              title: "app_language",
            ),
            SizedBox(height: 25.h),
            SettingsWidget(
              onTap: () => Navigation.push(ChangePasswordScreen()),
              icon: key,
              title: "change_password",
            ),
            SizedBox(height: 30.h),
            CustomButton(
              width: 1.sw,
              backgroundColor: AppColors.primaryColor,
              borderRadius: 8.r,
              buttonName: AppLocalization.of(context).translate("delete_account"),
              textStyle: AppTheme.headlineSmall.copyWith(color: AppColors.whiteColor),
              function: () {
                Dialogs.showQuestion(
                  context,
                  title: "",
                  content: StatefulBuilder(
                      builder: (context, setStateDialog) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(AppLocalization.of(context).translate("are_you_sure") +
                                  AppLocalization.of(context).translate("?"),
                                textAlign: TextAlign.center,
                                style: AppTheme.headlineSmall.copyWith(color: AppColors.mediumGrayColor),
                              ),
                            ),
                          ],
                        );
                      }
                  ),
                  btnOk: CreateModel(
                    withValidation: false,
                    onTap: () {},
                    onSuccess: (data) {
                      AppStorage.removeData(key: kAccessToken);
                      AppStorage.removeData(key: userID);
                      AppStorage.removeData(key: userType);
                      Navigation.pushAndRemoveUntil(SignInScreen());
                    },
                    useCaseCallBack: (model) {
                      return DeleteUserUseCase(ProfileRepository()).call(
                          params: DeleteUserParams());
                    },
                    child: CustomButton(
                      height: 40.h,
                      width: 1.sw,
                      backgroundColor: AppColors.redColor,
                      borderRadius: 8.r,
                      buttonName: AppLocalization.of(context).translate("ok"),
                      textStyle: AppTheme.headlineSmall.copyWith(color: AppColors.whiteColor),
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 30.h),
          ],
        )
      ),
    );
  }
}
