import 'package:flutter/material.dart';
import 'package:centro_partner/core/clasess/app_localization.dart';
import 'base_validator.dart';

class PhoneNumberValidator extends BaseValidator {
  String _value = "";

  PhoneNumberValidator({String? value}) {
    _value = value ?? "";
  }

  @override
  String getMessage(BuildContext context) {
    String message = '';

    if (_value.length != 10) {
      message += "${AppLocalization.of(context).translate("phone_must_be_10_characters")}\n";
    }
    if (!RegExp(r'^09\d{8}$').hasMatch(_value)) {
      message += "${AppLocalization.of(context).translate("phone_must_start_with_09")}\n";
    }

    return message;
  }

  @override
  bool validate(String value) {
    final startWith09 = RegExp(r'^09\d{8}$').hasMatch(value);

    return value.length == 10 && startWith09;
  }
}
