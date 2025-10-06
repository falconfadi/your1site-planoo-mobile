import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:centro_partner/core/constants/app_images.dart';
import '../../constants/app_colors.dart';
import '../../constants/app_styles.dart';

class CustomTextField extends StatefulWidget {
  final GlobalKey<FormFieldState<String>>? fieldStateKey;
  final bool? isPassword;
  final Color? labelColor;
  final Color? borderColor;
  final Color? focusedBorderColor;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final TextEditingController? textEditingController;
  final String? initialValue;
  final Function? onTab;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool canSubmit;
  final AutovalidateMode? autoValidateMode;
  final bool autoFocus;
  final String? labelText;
  final Widget? label;
  final TextStyle? labelStyle;
  final bool? enabled;
  final int? maxLine;
  final int? minLine;
  final Color? filledColor;
  final IconData? prefixIcon;
  final Color? prefixIconColor;
  final String? suffixIcon;
  final VoidCallback? onSuffixTap;

  const CustomTextField({
    super.key,
    this.fieldStateKey,
    this.autoFocus = false,
    this.readOnly = false,
    this.canSubmit = true,
    this.onChanged,
    this.isPassword = false,
    this.initialValue,
    this.textEditingController,
    this.onTab,
    this.keyboardType,
    this.focusNode,
    this.validator,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.nextFocusNode,
    this.autoValidateMode,
    this.labelColor,
    this.labelText,
    this.label,
    this.labelStyle,
    this.enabled=true,
    this.maxLine = 1,
    this.filledColor,
    this.prefixIcon,
    this.prefixIconColor,
    this.suffixIcon,
    this.borderColor,
    this.focusedBorderColor,
    this.minLine,
    this.textInputAction,
    this.onSuffixTap,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool showPassword = false;
  bool focused = false;

  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) widget.textEditingController?.value = TextEditingValue(text: widget.initialValue!);
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus && !focused) {
        if (mounted) setState(() => focused = true);
      } else if (!_focusNode.hasFocus && focused) {
        if (mounted) setState(() => focused = false);
        if (widget.validator != null && widget.textEditingController?.text.isEmpty == false) {
          widget.fieldStateKey?.currentState?.validate();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            key: widget.fieldStateKey,
            style: AppTheme.labelLarge.copyWith(fontSize: 18.sp),
            textAlignVertical: TextAlignVertical.center,
            keyboardType: widget.keyboardType ?? TextInputType.text,
            focusNode: _focusNode,
            cursorColor: AppColors.blackColor,
            cursorHeight: 20,
            onTap: widget.onTab as void Function()?,
            autofocus: widget.autoFocus,
            obscureText: widget.isPassword! ? !showPassword : false,
            validator: widget.validator,
            autovalidateMode: widget.autoValidateMode,
            onChanged: widget.onChanged,
            enabled: widget.enabled,
            maxLines: widget.maxLine,
            minLines: widget.minLine,
            initialValue: widget.initialValue,
            controller: widget.textEditingController,
            textInputAction:widget.textInputAction ?? (widget.nextFocusNode == null ? TextInputAction.done : TextInputAction.next),
            onFieldSubmitted: (text) {
              if (widget.nextFocusNode != null) {
                widget.nextFocusNode!.requestFocus();
                widget.fieldStateKey?.currentState?.validate();
              } else if (widget.canSubmit) {
                widget.onFieldSubmitted?.call(text);
              }
            },
            readOnly: widget.readOnly,
            inputFormatters: widget.keyboardType == TextInputType.number
                ? [FilteringTextInputFormatter.allow(RegExp('[0-9]'))]
                : widget.inputFormatters,
            decoration: InputDecoration(
              errorMaxLines: 2,
              fillColor: widget.filledColor ?? AppColors.whiteColor,
              filled: true,
              hint: widget.label,
              hintText: widget.labelText,
              hintStyle: widget.labelStyle ?? AppTheme.labelLarge.copyWith(color: AppColors.mediumGrayColor,fontSize: 18.sp),
              errorStyle: AppTheme.bodyLarge.copyWith(color: AppColors.redColor),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(width: 0.5,color: widget.borderColor ?? AppColors.mediumGrayColor),
              ),
              border: widget.enabled == null ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(width: 0.5,color: widget.borderColor ?? AppColors.mediumGrayColor),
              ) : InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(width: 0.5,color:widget.focusedBorderColor ?? AppColors.primaryColor),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(width: 1,color: AppColors.blackColor),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(width: 1,color: AppColors.redColor),
              ),
              prefixIcon: widget.prefixIcon != null ? Icon(widget.prefixIcon!,
                  color: widget.prefixIconColor ?? AppColors.grayColor, size: 20) : null,
              isCollapsed: true,
              contentPadding: EdgeInsets.only(left: 15.w,right: 15.w,top: 15.w,bottom: 8.w),
              suffixIcon: widget.suffixIcon != null ? IconButton(icon: SvgPicture.asset(widget.suffixIcon!,
                  color: AppColors.lightGrayColor, width: 25),
                  onPressed: widget.onSuffixTap) : widget.isPassword == true ? IconButton(icon: SvgPicture.asset(showPassword == false ? unVisiblePassword : visiblePassword,
                color: AppColors.blackColor, width: 25),
              onPressed: () {setState(() => showPassword = !showPassword);}) : null ,
            ),
          ),
        ],
    );
  }
}
