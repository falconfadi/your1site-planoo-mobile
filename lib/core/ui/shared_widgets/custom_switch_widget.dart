import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:flutter/cupertino.dart';

// ignore: must_be_immutable
class CustomSwitchWidget extends StatefulWidget {

  bool activate;
  double? scale;

  CustomSwitchWidget({super.key, required this.activate,this.scale});

  @override
  State<CustomSwitchWidget> createState() => _CustomSwitchWidgetState();
}

class _CustomSwitchWidgetState extends State<CustomSwitchWidget> {

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: widget.scale ?? 0.7,
      child: CupertinoSwitch(
        value: widget.activate,
        activeColor: AppColors.turquoiseColor,
        onChanged: (bool value) {
          setState(() {
            widget.activate = value;
          });
        },
      ),
    );
  }
}
