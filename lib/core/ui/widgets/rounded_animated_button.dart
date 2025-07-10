import 'package:flutter/material.dart';

class RoundedAnimatedButton extends StatefulWidget {
  final String text;
  final Color? color;
  final Widget? leadingImage;
  final bool? isLoading;
  final double? borderRadius;
  final double? width;
  final TextStyle? textStyle;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;

  const RoundedAnimatedButton(
      {super.key,
      required this.text,
      this.color,
      this.padding,
      this.borderRadius,
      this.leadingImage,
      this.width,
      this.textStyle,
      this.isLoading = false,
      this.onPressed});

  @override
  _RoundedAnimatedButtonState createState() => _RoundedAnimatedButtonState();
}

class _RoundedAnimatedButtonState extends State<RoundedAnimatedButton> {
  final Duration _animationDuration = const Duration(seconds: 1);
  ButtonStyle? flatButtonStyle;

  @override
  void initState() {
    flatButtonStyle = TextButton.styleFrom(
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.black),
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 0),
      ),
      backgroundColor: widget.color ?? Colors.blue,
      padding: const EdgeInsets.all(0),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: _animationDuration,
      child: _getAnimatedWidget(padding: widget.padding),
    );
  }

  Widget _getAnimatedWidget({EdgeInsetsGeometry? padding}) {
    if (widget.isLoading!) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: const <Widget>[
          Center(
              child: Center(
                  child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ))),
        ],
      );
    }
    return AnimatedContainer(
      duration: _animationDuration,
      width: 400,
      height: 40,
      child: TextButton(
        onPressed: widget.onPressed,
        style: flatButtonStyle,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            widget.leadingImage ?? Container(),
            SizedBox(
              width: widget.leadingImage != null ? 10 : 0,
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  widget.text,
                  style: widget.textStyle,
                ),
              ),
            ),
            Opacity(opacity: 0.0, child: widget.leadingImage ?? Container()),
          ],
        ),
      ),
    );
  }
}
