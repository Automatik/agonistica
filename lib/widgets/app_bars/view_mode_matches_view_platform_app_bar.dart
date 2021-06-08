// @dart=2.9

import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class ViewModeMatchesViewPlatformAppBar extends BasePlatformAppBar {

  final Function onActionBack;
  final Function onActionEditPress;

  ViewModeMatchesViewPlatformAppBar({
    @required title,
    this.onActionBack,
    this.onActionEditPress,
  }) : super(title: title, leading: composeLeading(onActionBack), actions: composeActions(onActionEditPress));

  static Widget composeLeading(Function onActionBack) {
    return BackArrowAppBarLeading(
      onLeadingTap: onActionBack,
    );
  }

  static List<Widget> composeActions(Function onActionEditPress) {
    return [
      AppBarAction(
        icon: Icons.edit,
        onActionTap: onActionEditPress,
      ),
    ];
  }

}