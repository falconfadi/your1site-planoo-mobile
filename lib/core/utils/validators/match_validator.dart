import 'package:flutter/material.dart';
import 'package:centro_partner/core/classes/app_localization.dart';

import 'base_validator.dart';

class MatchValidator extends BaseValidator {
  String value;

  MatchValidator({required this.value});

  @override
  String getMessage(BuildContext context) {
    return AppLocalization.of(context).translate("passwords_not_match");
  }

  @override
  bool validate(String value) {
    return value == this.value;
  }
}
