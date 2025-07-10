import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/clasess/app_storage.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/constants/end_point.dart';
import 'package:centro_partner/core/constants/enum/app_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';

class ChangeLanguageSheet extends StatefulWidget {

  ChangeLanguageSheet({Key? key}) : super(key: key);

  @override
  State<ChangeLanguageSheet> createState() => _ChangeLanguageSheetState();
}

class _ChangeLanguageSheetState extends State<ChangeLanguageSheet> {

  late AppLanguage selectedLanguage;

  @override
  void initState() {
    super.initState();
    final savedCode = AppStorage.getData(key: headerLanguageKey);
    selectedLanguage = AppLanguage.fromCode(savedCode);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.h),
        ListView.builder(
          shrinkWrap: true,
          itemCount: AppLanguage.values.length,
          itemBuilder: (context, index) {
            final language = AppLanguage.values[index];
            final isSelected = language == selectedLanguage;

            return Padding(
              padding: EdgeInsets.only(bottom: 30.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(language.name, style: AppTheme.titleSmall),
                  InkWell(
                    onTap: () {
                      setState(() {
                        selectedLanguage = language;
                      });
                    },
                    child: Icon(
                      Icons.radio_button_checked,
                      color: isSelected ? AppColors.primaryColor : AppColors.grayColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        CustomButton(
          width: 1.sw,
          backgroundColor: AppColors.primaryColor,
          borderRadius: 10.r,
          buttonName: AppLocalization.of(context).translate("save"),
          function: () {
            AppStorage.changeLanguage(context, selectedLanguage.code);
            Navigator.of(context).pop();
          },
        ),
        SizedBox(height: 50.h),
      ],
    );
  }
}
