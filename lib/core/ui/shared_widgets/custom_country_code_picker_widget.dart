import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCountryCodePickerWidget extends StatelessWidget {

  final void Function(CountryCode) onChanged;
  final String initialSelection;
  final bool enabled;

  const CustomCountryCodePickerWidget({super.key,
    required this.onChanged,
    required this.initialSelection,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);

    return AbsorbPointer(
      absorbing: !enabled,
      child: Opacity(
        opacity: enabled ? 1.0 : 0.8,
        child: CountryCodePicker(
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          closeIcon: Icon(
              Icons.close, size: isTablet ? 20.sp : null
          ),
          topBarPadding: isTablet ? EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w) :
          EdgeInsets.symmetric(vertical: 0.h, horizontal: 10.w),
          headerTextStyle: AppTheme.bodyLarge,
          searchDecoration: InputDecoration(
            prefixIcon: Icon(
                Icons.search,
                size: isTablet ? 20.sp : null
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 10.w,
              vertical: 18.h,
            ),
          ),
          onChanged: onChanged,
          initialSelection: initialSelection,
          showDropDownButton: enabled,
          padding: EdgeInsets.zero,
          hideMainText: true,
          showFlagMain: true,
          flagWidth: isTablet ? 70 : 25,
          dialogBackgroundColor: AppColors.whiteColor,
        ),
      ),
    );
  }
}
