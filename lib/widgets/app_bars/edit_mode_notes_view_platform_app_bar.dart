import 'package:agonistica/widgets/app_bar_actions/app_bar_action.dart';
import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class EditModeNotesViewPlatformAppBar extends BasePlatformAppBar {

  final Function()? onActionBack;
  final Function()? onActionCancel;
  final Function()? onActionConfirm;

  EditModeNotesViewPlatformAppBar({
    required title,
    this.onActionBack,
    this.onActionCancel,
    this.onActionConfirm,
  }) : super(title: title, leading: composeLeading(onActionBack), actions: composeActions(onActionCancel, onActionConfirm));

  static Widget composeLeading(Function()? onActionBack) {
    return BackArrowAppBarLeading(
      onLeadingTap: onActionBack,
    );
  }

  static List<Widget> composeActions(Function()? onActionCancel, Function()? onActionConfirm) {
    return [
      AppBarAction(
        icon: Icons.close,
        onActionTap: onActionCancel,
      ),
      AppBarAction(
        icon: Icons.done,
        onActionTap: onActionConfirm,
      ),
    ];
  }

}