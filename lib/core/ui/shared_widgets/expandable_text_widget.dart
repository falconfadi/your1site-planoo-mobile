import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/constants/app_colors.dart';
import 'package:centro_partner/core/constants/app_styles.dart';
import 'package:flutter/material.dart';

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

  final _textKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkOverflow());
  }

  void _checkOverflow() {
    final renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final lines = renderBox.size.height;
      if (lines > 3) {
        setState(() {
          _isOverflowing = true;
        });
      }
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
            key: _textKey,
            style: widget.style,
            overflow: TextOverflow.fade,
            maxLines: _expanded ? null : 3,
          ),
        ),
        if (_isOverflowing)
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: _expanded ? Center() : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalization.of(context).translate("see_more"),
                  style: AppTheme.textTheme.titleLarge!.copyWith(color: AppColors.turquoiseColor)
                ),
                Icon(Icons.keyboard_arrow_down_outlined,size: 18,color: AppColors.turquoiseColor)
              ],
            ),
          )
      ],
    );
  }
}
