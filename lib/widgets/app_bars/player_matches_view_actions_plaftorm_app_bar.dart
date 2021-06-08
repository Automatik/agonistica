// @dart=2.9

import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/add_action_platform_app_bar.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class PlayerMatchesViewActionsPlatformAppBar extends BasePlatformAppBar {

  final Function onActionBack;
  final Function onActionTap;

  PlayerMatchesViewActionsPlatformAppBar({
    @required title,
    this.onActionBack,
    this.onActionTap
  }) : super(title: title, leading: composeLeading(onActionBack), actions: AddActionPlatformAppBar.composeActions(onActionTap));

  static Widget composeLeading(Function onActionBack) {
    return BackArrowAppBarLeading(
      onLeadingTap: onActionBack,
    );
  }

}