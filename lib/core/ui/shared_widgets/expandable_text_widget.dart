import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandableTextWidget extends StatefulWidget {

  final String text;
  final TextStyle? style;

  const ExpandableTextWidget({
    super.key,
    required this.text,
    this.style,
  });

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {

  bool _expanded = false;
  bool _isOverflowing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final textSpan = TextSpan(
      text: widget.text,
      style: widget.style ?? AppTheme.titleMedium,
    );

    final textPainter = TextPainter(
      text: textSpan,
      maxLines: 3,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(
      maxWidth: context.size?.width ?? double.infinity,
    );

    if (textPainter.didExceedMaxLines) {
      setState(() => _isOverflowing = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _isOverflowing ? () => setState(() => _expanded = !_expanded) : null,
          child: Text(
            widget.text,
            style: widget.style ?? AppTheme.titleMedium,
            overflow: TextOverflow.fade,
            maxLines: _expanded ? null : 3,
          ),
        ),
        if (_isOverflowing)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: _expanded ? const SizedBox.shrink() : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(context).translate("see_more"),
                  style: AppTheme.titleLarge.copyWith(color: AppColors.turquoiseColor)
                ),
                Icon(Icons.keyboard_arrow_down_outlined,size: 18.sp,color: AppColors.turquoiseColor)
              ],
            ),
          )
      ],
    );
  }
}
