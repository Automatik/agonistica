import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

class AppBarAction extends StatelessWidget {

  static const double actionIconsMargin = 12;

  final IconData icon;
  final Function onActionTap;
  final Color color;
  final double rightMargin;

  AppBarAction({
    @required this.icon,
    this.onActionTap,
    this.color = blueAgonisticaColor,
    this.rightMargin = actionIconsMargin,
  }) : assert(icon != null);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: rightMargin),
      child: GestureDetector(
        onTap: this.onActionTap,
        child: Icon(
          this.icon,
          color: this.color,
        ),
      ),
    );
  }



}