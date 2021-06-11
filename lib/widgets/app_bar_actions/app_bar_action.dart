import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

class AppBarAction extends StatelessWidget {

  static const double actionIconsMargin = 20;

  final IconData icon;
  final Function(TapDownDetails)? onActionTapDown;
  final Function()? onActionTap;
  final Color color;
  final double rightMargin;

  AppBarAction({
    required this.icon,
    this.onActionTap,
    this.onActionTapDown,
    this.color = blueAgonisticaColor,
    this.rightMargin = actionIconsMargin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: rightMargin),
      child: GestureDetector(
        onTap: this.onActionTap,
        onTapDown: this.onActionTapDown,
        child: Icon(
          this.icon,
          color: this.color,
        ),
      ),
    );
  }



}