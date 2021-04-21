import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class AddActionPlatformAppBar extends BasePlatformAppBar {

  final Function onActionTap;

  AddActionPlatformAppBar({
    @required title,
    this.onActionTap,
  }) : super(title: title, actions: composeActions(onActionTap));

  static List<Widget> composeActions(Function onActionTap) {
    return [
      addAction(onActionTap),
    ];
  }

  static Widget addAction(Function onActionTap) {
    return AppBarAction(
      icon: Icons.add,
      onActionTap: onActionTap,
    );
  }

}