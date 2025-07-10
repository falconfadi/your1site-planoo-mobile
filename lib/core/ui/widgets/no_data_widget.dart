import 'package:flutter/material.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_styles.dart';

class NoDataWidget extends StatelessWidget {
  const NoDataWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(AppLocalization.of(context).translate("no_data_found"),
        style: AppTheme.titleLarge,
      ),
    );
  }
}
