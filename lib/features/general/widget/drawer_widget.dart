import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/classes/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/ui/dialogs/dialogs.dart';
import 'package:centro_partner/core/ui/shared_widgets/expandable_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/logout_usecase.dart';
import 'package:centro_partner/features/auth/ui/sign_in_screen.dart';
import 'package:centro_partner/features/general/ui/about_screen.dart';
import 'package:centro_partner/features/general/ui/settings_screen.dart';
import 'package:centro_partner/features/general/ui/terms_and_conditions_screen.dart';
import 'package:centro_partner/features/general/widget/drawer_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DrawerWidget extends StatelessWidget {

  DrawerWidget({super.key});

  bool clearToken = false;

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return Drawer(
      width: 0.7.sw,
      child: ListView(
        children: [
          SizedBox(height: 20.h),
          Image.asset(miniLogo,width: 100.w,height: 100.w),
          DrawerItem(
            title: AppLocalization.of(context).translate("settings"),
            iconPath: settings,
            onTap: () => Navigation.push(SettingsScreen()),
          ),
          DrawerItem(
            title: AppLocalization.of(context).translate("about"),
            iconPath: about,
            onTap: () => Navigation.push(AboutScreen()),
          ),
          DrawerItem(
            title: AppLocalization.of(context).translate("terms_and_conditions"),
            iconPath: termsAndCondition,
            onTap: () => Navigation.push(TermsAndConditionsScreen()),
          ),
          DrawerItem(
            title: AppLocalization.of(context).translate("log_out"),
            iconPath: logout,
            onTap: () {
              clearToken = false;
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
                          subtitle: Padding(
                              padding: EdgeInsets.only(top: 10.h),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Transform.scale(
                                    scale: isTablet ? 1.8 : 1,
                                    child: Checkbox(
                                      value: clearToken,
                                      activeColor: AppColors.redColor,
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      onChanged: (value) {
                                        setStateDialog(() {
                                          clearToken = !clearToken;
                                        });
                                      },
                                    ),
                                  ),
                                  SizedBox(width: isTablet ? 5.w : 0),
                                  Expanded(
                                      child: ExpandableTextWidget(
                                        text: AppLocalization.of(context).translate("logout_clear_token_warning"),
                                        style: AppTheme.bodyMedium,
                                      )
                                  )
                                ],
                              ),
                            )
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
                    return LogoutUseCase(AuthRepository()).call(
                        params: LogoutParams(
                          clearToken: clearToken
                        ));
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
        ],
      ),
    );
  }
}