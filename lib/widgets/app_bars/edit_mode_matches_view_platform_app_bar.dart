import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class EditModeMatchesViewPlatformAppBar extends StatelessWidget {

  final String title;
  final Function onActionBack;
  final Function onActionCancel;
  final Function onActionConfirm;

  EditModeMatchesViewPlatformAppBar({
    @required this.title,
    this.onActionBack,
    this.onActionCancel,
    this.onActionConfirm,
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
          icon: Icons.close,
          onActionTap: onActionCancel,
        ),
        AppBarAction(
          icon: Icons.done,
          onActionTap: onActionConfirm,
        ),
      ],
    );
  }

}