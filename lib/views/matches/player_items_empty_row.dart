// @dart=2.9

import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

class PlayerItemsEmptyRow extends StatelessWidget {

  final Function onTap;

  final double iconSize = 24;

  PlayerItemsEmptyRow({ this.onTap });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: GestureDetector(
        onTap: onTap,
        child: Icon(
          Icons.add_circle_outline,
          color: blueAgonisticaColor,
          size: iconSize,
        ),
      ),
    );
  }



}