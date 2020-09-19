import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import 'base_widget.dart';

class BaseScaffoldWidget extends StatefulWidget {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final Widget Function(BuildContext context, SizingInformation sizingInformation) childBuilder;
  final String title;
  final bool showAppBar;

  BaseScaffoldWidget({
    this.childBuilder,
    this.title = defaultAppBarTitle,
    this.showAppBar = true,
  });

  @override
  State<StatefulWidget> createState() => _BaseScaffoldWidgetState();

}

class _BaseScaffoldWidgetState extends State<BaseScaffoldWidget> {

  @override
  Widget build(BuildContext context) {

    return PlatformScaffold(
        appBar: widget.showAppBar ? getPlatformAppBar(widget.title) : null,
        body: Builder(
            builder: (BuildContext innerContext) {
              widget._baseScaffoldService.scaffoldContext = innerContext;
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [blueLightAgonisticaColor, blueAgonisticaColor],
                  ),
                ),
                child: BaseWidget(
                  builder: (baseContext, sizingInfo) {
                    return Expanded(
                      child: BaseWidget(
                        builder: widget.childBuilder,
                      ),
                    );
                  },
                ),
              );
            }
        )
    );
  }

  bool isPortraitOrientation(double width, double height) {
    return height >= width;
  }

  static PlatformAppBar getPlatformAppBar(String title) {
    return PlatformAppBar(
      backgroundColor: appBarBackgroundColor,
      title: Text(
        title,
        style: TextStyle(
          color: blueAgonisticaColor,
        ),
      ),
      material: (_, __) => MaterialAppBarData(

      )
    );
  }

}