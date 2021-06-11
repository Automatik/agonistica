import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/app_bar_actions/app_bar_leading.dart';
import 'package:flutter/material.dart';

class BackArrowAppBarLeading extends StatelessWidget {

  final Function()? onLeadingTap;
  final Color color;

  BackArrowAppBarLeading({
    this.onLeadingTap,
    this.color = blueAgonisticaColor,
  });

  @override
  Widget build(BuildContext context) {
    return AppBarLeading(
      icon: Icons.arrow_back,
      onLeadingTap: onLeadingTap,
      color: color,
    );
  }

}