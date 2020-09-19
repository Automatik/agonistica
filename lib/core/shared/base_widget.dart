import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BaseWidget extends StatelessWidget {

  final Widget Function(BuildContext context, MySizingInformation sizingInformation) builder;
  const BaseWidget({Key key, this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);

    return LayoutBuilder(
      builder: (context, boxSizing) {
        var sizingInformation = MySizingInformation(
            orientation: mediaQuery.orientation,
            screenSize: mediaQuery.size,
            localWidgetSize: Size(boxSizing.maxWidth, boxSizing.maxHeight),
        );
        return builder(context, sizingInformation);
      }
    );
  }

}

class MySizingInformation {
  final Orientation orientation;
  final Size screenSize;
  final Size localWidgetSize;

  MySizingInformation({
    this.orientation,
    this.screenSize,
    this.localWidgetSize,
  });

  bool isPortrait() {
    return orientation == Orientation.portrait;
  }

  bool isTablet() {
    return getDeviceType(screenSize) == DeviceScreenType.tablet;
  }

}