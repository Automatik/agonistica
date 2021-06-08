// @dart=2.9

import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class PlayerMatchesViewPlatformAppBar extends BasePlatformAppBar {

  final Function onActionBack;

  PlayerMatchesViewPlatformAppBar({
    @required title,
    this.onActionBack,
  }) : super(title: title, leading: composeLeading(onActionBack));

  static Widget composeLeading(Function onActionBack) {
    return BackArrowAppBarLeading(
      onLeadingTap: onActionBack,
    );
  }

}