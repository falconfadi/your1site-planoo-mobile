import 'package:flutter/material.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import '../validators/base_validator.dart';

class PasswordValidator extends BaseValidator {

  String _value = "";

  PasswordValidator({String? value}) {
    _value = value!;
  }

  @override
  String getMessage(BuildContext context) {
    String message = '';

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(_value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(_value);
    final hasDigit = RegExp(r'\d').hasMatch(_value);
    final hasSpecialChar = RegExp(r'\W').hasMatch(_value);

    if (_value.length < 8) {
      message += "${AppLocalization.of(context).translate("password_must_be_8_characters")}\n";
    }
    if (!(hasUppercase && hasLowercase && hasDigit)) {
      message += "${AppLocalization.of(context).translate("password_contains_upper_lower_numbers")}\n";
    }
    if (!hasSpecialChar) {
      message += "${AppLocalization.of(context).translate("password_contain_special_character")}\n";
    }

    return message;
  }

  @override
  bool validate(String value) {
    final hasUppercase = RegExp(r'[A-Z]').hasMatch(_value);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(_value);
    final hasDigit = RegExp(r'\d').hasMatch(_value);
    final hasSpecialChar = RegExp(r'\W').hasMatch(value);

    if (value.length < 8 || !(hasUppercase && hasLowercase && hasDigit) || !hasSpecialChar) {
      return false;
    }

    return true;
  }
}
