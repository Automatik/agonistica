import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class ViewModeRosterViewPlatformAppBar extends StatelessWidget {

  final String title;
  final Function onActionBack;
  final Function onActionEditPress;
  final Function onActionNotesPress;

  ViewModeRosterViewPlatformAppBar({
    @required this.title,
    this.onActionBack,
    this.onActionEditPress,
    this.onActionNotesPress,
  });

  @override
  Widget build(BuildContext context) {
    return BasePlatformAppBar(
      title: title,
      leading: BackArrowAppBarLeading(
        onLeadingTap: this.onActionBack,
      ),
      actions: [
        AppBarAction(
          icon: Icons.edit,
          onActionTap: onActionEditPress,
        ),
        AppBarAction(
          icon: Icons.assignment_rounded,
          onActionTap: onActionNotesPress,
        ),
      ],
    );
  }

}