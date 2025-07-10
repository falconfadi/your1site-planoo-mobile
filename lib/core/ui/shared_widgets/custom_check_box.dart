import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCheckBox extends StatefulWidget {

  bool check;
  String text;
  void Function(bool?) onChanged;
  VisualDensity? visualDensity;

  CustomCheckBox({super.key,required this.check,required this.text,required this.onChanged,this.visualDensity});

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {

  @override
  Widget build(BuildContext context) {
    return Row(
        children: [
          Checkbox(
            activeColor: AppColors.primaryColor,
            visualDensity: widget.visualDensity ?? VisualDensity(horizontal: -1, vertical: -1),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            value: widget.check,
            onChanged: widget.onChanged
          ),
          SizedBox(width: 5.w),
          Expanded(
            child: Text(widget.text,
              style: AppTheme.labelMedium,
            ),
          ),
    ]);
  }
}
