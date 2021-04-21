import 'package:agonistica/widgets/app_bar_actions/back_arrow_app_bar_leading.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:flutter/material.dart';

class PlayerMatchesViewPlatformAppBar extends StatelessWidget {

  final String title;
  final Function onActionBack;

  PlayerMatchesViewPlatformAppBar({
    @required this.title,
    this.onActionBack,
  });

  @override
  Widget build(BuildContext context) {
    return BasePlatformAppBar(
      title: title,
      leading: BackArrowAppBarLeading(
        onLeadingTap: this.onActionBack,
      ),
    );
  }

}