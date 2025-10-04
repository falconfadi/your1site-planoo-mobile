import 'package:flutter/material.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import '../validators/base_validator.dart';

class EmailValidator extends BaseValidator {
  @override
  String getMessage(BuildContext context) {
    return AppLocalization.of(context).translate("invalid_email");
  }

  @override
  bool validate(String value) {
    final regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{1,}))$');
    return regex.hasMatch(value.trim());
  }
}
