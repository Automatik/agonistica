import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class AddActionPlatformAppBar extends StatelessWidget {

  final String title;
  final Function onActionTap;

  AddActionPlatformAppBar({
    @required this.title,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return BasePlatformAppBar(
      title: title,
      actions: composeActions(),
    );
  }

  List<Widget> composeActions() {
    return [
      addAction(),
    ];
  }

  Widget addAction() {
    return AppBarAction(
      icon: Icons.add,
      onActionTap: this.onActionTap,
    );
  }

}