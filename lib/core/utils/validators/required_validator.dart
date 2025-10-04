import 'package:flutter/material.dart';
import 'package:centro_partner/core/classes/app_localization.dart';

import 'base_validator.dart';

class RequiredValidator extends BaseValidator {

  @override
  String getMessage(BuildContext context) {
    return "${AppLocalization.of(context).translate('field_required')} * ";
  }

  @override
  bool validate(String value) {
    return value.isNotEmpty;
  }
}
