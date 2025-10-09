import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';

class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(color: AppColors.turquoiseColor);
  }
}
