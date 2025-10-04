import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:centro_partner/core/errors/bad_request_error.dart';
import 'package:centro_partner/core/errors/not_found_error.dart';
import '/core/ui/widgets/rounded_animated_button.dart';
import 'package:flutter/material.dart';
import '../../errors/error_helper.dart';
import '../../errors/unauthorized_error.dart';

// ignore: must_be_immutable
class GeneralErrorWidget extends StatefulWidget {

  final VoidCallback? onTap;
  Widget? body;
  final error;
  final String? message;
  final String? buttonText;

  GeneralErrorWidget({
    super.key,
    this.onTap,
    this.message,
    this.body,
    this.error,
    this.buttonText,
  });

  @override
  State<GeneralErrorWidget> createState() => _GeneralErrorWidgetState();
}

class _GeneralErrorWidgetState extends State<GeneralErrorWidget> {
  final errorHelper = ErrorHelper();

  @override
  void initState() {
    if (widget.error is UnauthorizedError) {
      /// TODO : Handle UnauthorizedError (toWorkOn)
    } else {
      widget.body = Center(
        child: Container(
          color: Colors.white,
          //child: Image.asset('assets/images/error.png'),
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.error is UnauthorizedError) {
      /// TODO : Handle UnauthorizedError (toWorkOn)
    } else {
      widget.body = Center(
          //child: Image.asset('assets/images/error.png'),
          );
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget.body ?? Container(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              widget.message ?? errorHelper.getErrorMessage(widget.error),
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (widget.error is NotFoundError || widget.error is BadRequestError ||
              widget.error is UnauthorizedError)
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.4,
              child: RoundedAnimatedButton(
                //borderRadius: 15,
                onPressed: widget.onTap,
                text: widget.buttonText ?? AppLocalization.of(context).translate("try_again"),
                color: Colors.black,
                textStyle: const TextStyle(color: Colors.white),
              ),
            )
        ],
      ),
    );
  }
}
