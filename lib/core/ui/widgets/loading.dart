import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:flutter/cupertino.dart';

class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return CupertinoActivityIndicator(
        radius: isTablet ? 20.0 : 10.0,
        color: AppColors.turquoiseColor);
  }
}
