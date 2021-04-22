import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/app_bar_actions/app_bar_leading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class BasePlatformAppBar extends PlatformAppBar {

  final Widget leading;
  final List<Widget> actions;

  BasePlatformAppBar({
    @required title,
    this.leading,
    this.actions,
  }) : super(
      backgroundColor: appBarBackgroundColor,
      title: composeTitle(title),
      material: (_, __) => composeMaterialData(leading, actions)
  );

  static Widget composeTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: blueAgonisticaColor,
      ),
    );
  }

  static Widget chooseLeading(Widget leading) {
    return leading == null ? defaultLeading() : leading;
  }

  static MaterialAppBarData composeMaterialData(Widget leading, List<Widget> actions) {
    return MaterialAppBarData(
      leading: chooseLeading(leading),
      actions: actions,
    );
  }

  static Widget defaultLeading() {
    return AppBarLeading();
  }

}