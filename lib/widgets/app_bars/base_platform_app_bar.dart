import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/app_bar_actions/drawer_menu_app_bar_leading.dart';
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
        material: (_, __) => composeMaterialData(title, leading, actions),
      );

  static MaterialAppBarData composeMaterialData(String title, Widget leading, List<Widget> actions) {
    return MaterialAppBarData(
      title: composeTitle(title),
      leading: chooseLeading(leading),
      actions: actions,
      backgroundColor: appBarBackgroundColor,
      shape: CustomShapeBorder(),
    );
  }

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

  static Widget defaultLeading() {
    return DrawerMenuAppBarLeading();
  }

}

class CustomShapeBorder extends ContinuousRectangleBorder {

  CustomShapeBorder() : super(side: BorderSide(color: blueAgonisticaColor, width: 1));

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    Path path = Path();
    path.lineTo(0.0, rect.height + 40);

    path.cubicTo(-3, rect.height - 15, 2, rect.height, rect.width - 50, rect.height);

    path.cubicTo(rect.width -15, rect.height, rect.width - 10, rect.height - 8, rect.width, rect.height -30);

    path.lineTo(rect.width, 0);
    path.close();

    return path;
  }

}