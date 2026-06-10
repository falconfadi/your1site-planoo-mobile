import 'package:flutter/material.dart';

class Responsive {

  static bool isTablet(BuildContext context) {
    return MediaQuery.of(context).size.width >= 600;
  }
}