import 'package:centro_partner/core/clasess/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_header.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_texts_widget.dart';
import 'package:centro_partner/core/ui/shared_widgets/icon_text_widget.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PartnerDetailsScreen extends StatefulWidget {

  const PartnerDetailsScreen({super.key});

  @override
  State<PartnerDetailsScreen> createState() => _PartnerDetailsScreenState();
}

class _PartnerDetailsScreenState extends State<PartnerDetailsScreen> with FormStateMinxin {

  @override
  void initState() {
    super.initState();
    form.controllers[0].text = "Open from 6 AM to 10 PM";
  }

  @override
  void dispose() {
    form.controllers[0].dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: CustomHeader(
        isNavBar: false,
        title: AppLocalization.of(context).translate("partner_details"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 30.w,vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            IconTextWidget(
                icon: phone,
                iconSize: 20,
                iconColor: AppColors.blackColor,
                text: "09987455587"
            ),
            SizedBox(height: 10.h),
            IconTextWidget(
                icon: email,
                iconSize: 20,
                iconColor: AppColors.blackColor,
                text: "maya@gmail.com"
            ),
            SizedBox(height: 10.h),
            CustomTextsWidget(title: "${AppLocalization.of(context).translate("account_type")}:", text: "court"),
            SizedBox(height: 10.h),
            CustomTextsWidget(title: "${AppLocalization.of(context).translate("description")}:",text: null),
            SizedBox(height: 8.h),
            Form(
              key: form.key,
              child: CustomTextField(
                autoFocus: false,
                maxLine: 4,
                autoValidateMode: AutovalidateMode.onUserInteraction,
                keyboardType: TextInputType.text,
                focusNode: form.nodes[0],
                textEditingController: form.controllers[0],
                labelText: form.controllers[0].text,
                onChanged: (value) {
                  setState(() {
                    form.controllers[0].text = value;
                  });
                },
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  CustomButton(
                    backgroundColor: AppColors.whiteColor,
                    width: 0,
                    height: 30,
                    borderRadius: 0,
                    buttonName: AppLocalization.of(context).translate("save"),
                    textStyle: AppTheme.titleSmall.copyWith(color: AppColors.primaryColor,fontSize: 15),
                    function: () {
                      // todo edit the description
                    },
                  ),
                ]
            ),
            SizedBox(height: 50.h),
          ],
        ),
      ),
    );
  }

  @override
  int numberOfFields() => 1;
}
