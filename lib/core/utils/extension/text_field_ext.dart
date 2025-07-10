import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import '../form_utils/form_utils.dart';

extension FormExt on Tuple3<GlobalKey<FormState>, List<TextEditingController>, List<FocusNode>> {
  GlobalKey<FormState> get key => item1;
  List<TextEditingController> get controllers => item2;
  List<FocusNode> get nodes => item3;

  void dispose() => disposeForm(this);

  bool validate() {
    if (key.currentState!.validate()) {
      key.currentState!.save();
      return true;
    } else {
      return false;
    }
  }
}
