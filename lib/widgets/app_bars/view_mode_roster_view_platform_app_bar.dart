import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class ViewModeRosterViewPlatformAppBar extends BasePlatformAppBar {

  final Function onActionBack;
  final Function onActionEditPress;
  final Function onActionNotesPress;

  ViewModeRosterViewPlatformAppBar({
    @required title,
    this.onActionBack,
    this.onActionEditPress,
    this.onActionNotesPress,
  }) : super(title: title, leading: composeLeading(onActionBack), actions: composeActions(onActionEditPress, onActionNotesPress));

  static Widget composeLeading(Function onActionBack) {
    return BackArrowAppBarLeading(
      onLeadingTap: onActionBack,
    );
  }

  static List<Widget> composeActions(Function onActionEditPress, Function onActionNotesPress) {
    return [
      AppBarAction(
        icon: Icons.edit,
        onActionTap: onActionEditPress,
      ),
      AppBarAction(
        icon: Icons.assignment_rounded,
        onActionTap: onActionNotesPress,
      ),
    ];
  }

}