import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';
import 'form_utils.dart';

mixin FormStateMinxin<T extends StatefulWidget> on State<T> {
  late final Tuple3<GlobalKey<FormState>, List<TextEditingController>, List<FocusNode>> form;

  int numberOfFields();

  @override
  void initState() {
    super.initState();
    form = generateForm(numberOfFields: numberOfFields());
  }

  @override
  void dispose() {
    form.dispose();
    super.dispose();
  }
}
