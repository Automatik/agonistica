import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'base_widget.dart';
import 'shared_variables.dart';

class ScrollScaffoldWidget extends StatefulWidget {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final Widget Function(BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) childBuilder;
  final String title, previousWidgetTitle;
  final bool showAppBar;
  final bool showBottomBar;

  ScrollScaffoldWidget({
    this.childBuilder,
    this.title = defaultAppBarTitle,
    this.previousWidgetTitle,
    this.showAppBar = true,
    this.showBottomBar = true,
  });

  @override
  State<StatefulWidget> createState() => _ScrollScaffoldWidgetState();

}

class _ScrollScaffoldWidgetState extends State<ScrollScaffoldWidget> {

  @override
  Widget build(BuildContext context) {

    return PlatformScaffold(
      appBar: widget.showAppBar ? Utils.getPlatformAppBar(widget.title) : null,
      body: Builder(
          builder: (BuildContext innerContext) {
            widget._baseScaffoldService.scaffoldContext = innerContext;
            return BaseWidget(
                builder: (baseContext, sizingInfo, parentSizingInfo) {
                  return SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [blueLightAgonisticaColor, blueAgonisticaColor]
                        )
                      ),
                      constraints: BoxConstraints(
                        minHeight: sizingInfo.localWidgetSize.height,
                      ),
                      child: BaseWidget(
                        parentSizingInformation: sizingInfo,
                        builder: widget.childBuilder,
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }

}