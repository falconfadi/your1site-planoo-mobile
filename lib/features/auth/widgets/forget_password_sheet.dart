import 'package:centro_partner/core/boilerplate/create_model/widgets/create_model.dart';
import 'package:centro_partner/core/classes/firebase_api.dart';
import 'package:centro_partner/core/ui/shared_widgets/custom_country_code_picker_widget.dart';
import 'package:centro_partner/core/utils/Navigation/Navigation.dart';
import 'package:centro_partner/core/utils/responsive/responsive.dart';
import 'package:centro_partner/features/auth/data/auth_repository/auth_repository.dart';
import 'package:centro_partner/features/auth/data/usecase/forget_password_usecase.dart';
import 'package:centro_partner/features/auth/ui/reset_password_screen.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/ui/widgets/custom_button.dart';
import 'package:centro_partner/core/utils/form_utils/form_state_mixin.dart';
import 'package:centro_partner/core/ui/widgets/custom_text_field.dart';
import 'package:centro_partner/core/utils/extension/text_field_ext.dart';
import 'package:centro_partner/core/utils/validators/base_validator.dart';
import 'package:centro_partner/core/utils/validators/required_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';

class ForgetPasswordSheet extends StatefulWidget {

  final String countryDialCode;
  final String selectedIsoCode;

  const ForgetPasswordSheet({super.key,
    required this.countryDialCode,
    required this.selectedIsoCode
  });

  @override
  State<ForgetPasswordSheet> createState() => _ForgetPasswordSheetState();
}

class _ForgetPasswordSheetState extends State<ForgetPasswordSheet>  with FormStateMinxin {

  @override
  Widget build(BuildContext context) {
    final isTablet = Responsive.isTablet(context);
    return SizedBox(
      child: Form(
        key: form.key,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: isTablet ? 15.h : 5.h),
                  child: CustomCountryCodePickerWidget(
                    enabled: false,
                    initialSelection: widget.countryDialCode,
                    onChanged: (CountryCode countryCode) {},
                  ),
                ),
                Expanded(
                  child: CustomTextField(
                    autoFocus: false,
                    autoValidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      final baseError = BaseValidator.validateValue(
                        context,
                        value ?? '',
                        [RequiredValidator()],
                      );
                      if (baseError != null) return baseError;
                      try {
                        final targetIso = IsoCode.values.firstWhere(
                              (element) => element.name == widget.selectedIsoCode.toUpperCase(),
                          orElse: () => IsoCode.IQ,
                        );
                        final parsedPhone = PhoneNumber.parse(
                          value!.trim(),
                          callerCountry: targetIso,
                        );

                        if (!parsedPhone.isValid()) {
                          return AppLocalization.of(context).translate("invalid_country_phone");
                        }
                      } catch (e) {
                        return AppLocalization.of(context).translate("invalid_phone_format");
                      }
                      return null;
                    },
                    focusNode: form.nodes[0],
                    textEditingController: form.controllers[0],
                    labelText: AppLocalization.of(context).translate("phone"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 50.h),
            CreateModel(
                onSuccess: (model) async {
                  Navigation.popThenPush(ResetPasswordScreen(
                    phone: form.controllers[0].text,
                    countryDialCode: widget.countryDialCode,
                  ));
                },
                withValidation: true,
                onTap: () {
                  return form.validate();
                },
                useCaseCallBack: (model) {
                  return ForgetPasswordUseCase(AuthRepository()).call(
                      params: ForgetPasswordParams(
                        phone: form.controllers[0].text,
                        countryCode: widget.countryDialCode,
                        firebaseToken: FirebaseApi.deviceToken.toString()
                      )
                  );
                },
                child: CustomButton(
                  width: 1.sw,
                  backgroundColor: AppColors.primaryColor,
                  borderRadius: 10.r,
                  buttonName: AppLocalization.of(context).translate("send"),
                ),
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
