import 'package:flutter/cupertino.dart';
import 'package:centro_partner/core/classes/app_localization.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

var customFooter = CustomFooter(

  builder: (BuildContext? context, LoadStatus? mode) {
    final loc = AppLocalization.of(context!);
    late final Widget body;

    switch (mode) {
      case LoadStatus.idle:
        body = Text(loc.translate("pull_up_to_load"));
        break;
      case LoadStatus.loading:
        body = const CupertinoActivityIndicator();
        break;
      case LoadStatus.failed:
        body = Text(loc.translate("load_failed"));
        break;
      case LoadStatus.canLoading:
        body = Text(loc.translate("release_to_load_more"));
        break;
      default:
        body = Text(loc.translate("no_data_found"));
    }
    return SizedBox(
      height: 55.0,
      child: Center(child: body),
    );
  },
);