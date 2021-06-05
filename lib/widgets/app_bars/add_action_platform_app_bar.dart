import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class AddActionPlatformAppBar extends BasePlatformAppBar {

  final Function(TapDownDetails) onActionTapDown;
  final Function onActionTap;

  AddActionPlatformAppBar({
    @required title,
    this.onActionTap,
    this.onActionTapDown,
  }) : super(title: title, actions: composeActions(onActionTap, onActionTapDown));

  static List<Widget> composeActions(Function onActionTap, [Function(TapDownDetails) onActionTapDown]) {
    return [
      addAction(onActionTap, onActionTapDown),
    ];
  }

  static Widget addAction(Function onActionTap, [Function(TapDownDetails) onActionTapDown]) {
    return AppBarAction(
      icon: Icons.add,
      onActionTap: onActionTap,
      onActionTapDown: onActionTapDown,
    );
  }

}