import 'package:flutter/cupertino.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key, this.padding});

  final double? padding;

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: CupertinoActivityIndicator(),
    );
  }
}
