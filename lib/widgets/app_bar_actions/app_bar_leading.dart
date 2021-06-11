import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

class AppBarLeading extends StatelessWidget {

  final IconData icon;
  final Function()? onLeadingTap;
  final Color color;

  AppBarLeading({
    this.icon = Icons.menu,
    this.onLeadingTap,
    this.color = blueAgonisticaColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onLeadingTap,
      child: Icon(
        this.icon,
        color: blueAgonisticaColor,
      ),
    );
  }

}