// @dart=2.9

import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

class AppColor {

  static LinearGradient getBackground() {
    return LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [blueLightAgonisticaColor, blueAgonisticaColor]
    );
  }

  static Color getScaffoldBackground() {
    return blueLightAgonisticaColor;
  }

}