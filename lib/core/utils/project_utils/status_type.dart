
import 'package:centro_partner/core/constants/app_colors.dart';

class StatusType {

  Map<String, dynamic> getStatusInfo(int status) {
    switch (status) {
      case 0:
        return {
          "text": "accepted",
          "color": AppColors.primaryColor,
        };
      case 1:
        return {
          "text": "completed",
          "color": AppColors.darkGreenColor,
        };
      case -1:
        return {
          "text": "canceled",
          "color": AppColors.redColor,
        };
      default:
        return {
          "text": "Unknown",
          "color": AppColors.blackColor,
        };
    }
  }
}