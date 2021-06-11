import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:flutter/material.dart';

class BaseWidget extends StatelessWidget {

  final Widget Function(BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) builder;
  final MySizingInformation parentSizingInformation;

  const BaseWidget({Key? key, required this.builder, required this.parentSizingInformation}) : super(key: key);

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
        return builder(context, sizingInformation, parentSizingInformation);
      }
    );
  }

}