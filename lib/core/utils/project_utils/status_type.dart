import 'package:centro_partner/core/constants/app_colors.dart';

class StatusType {

  Map<String, dynamic> getStatusInfo(String status) {
    switch (status) {
      case "accepted":
        return {
          "color": AppColors.primaryColor,
        };
      case "completed":
        return {
          "color": AppColors.darkGreenColor,
        };
      case "canceled":
        return {
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