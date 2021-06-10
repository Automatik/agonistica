

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MySizingInformation {
  final Orientation orientation;
  final Size screenSize;
  final Size localWidgetSize;

  MySizingInformation({
    required this.orientation,
    required this.screenSize,
    required this.localWidgetSize,
  });

  bool isPortrait() {
    return orientation == Orientation.portrait;
  }

  bool isTablet() {
    // not working for iPads, see working solution in stili_sociali project
    return getDeviceType(screenSize) == DeviceScreenType.tablet;
  }

}