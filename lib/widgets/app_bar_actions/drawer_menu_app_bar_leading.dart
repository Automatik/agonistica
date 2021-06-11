import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/app_bar_actions/app_bar_leading.dart';
import 'package:flutter/material.dart';

class DrawerMenuAppBarLeading extends StatelessWidget {

  final Color color;

  DrawerMenuAppBarLeading({
    this.color = blueAgonisticaColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarLeading(
      icon: Icons.menu,
      onLeadingTap: () => Scaffold.of(context).openDrawer(),
      color: color,
    );
  }

}