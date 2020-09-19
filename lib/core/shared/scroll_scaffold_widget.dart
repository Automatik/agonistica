import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'base_widget.dart';
import 'shared_variables.dart';

class ScrollScaffoldWidget extends StatefulWidget {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final Widget Function(BuildContext context, SizingInformation sizingInformation) childBuilder;
  final String title, previousWidgetTitle;
  final bool showBottomBar;

  ScrollScaffoldWidget({
    this.childBuilder,
    this.title = defaultAppBarTitle,
    this.previousWidgetTitle,
    this.showBottomBar = true,
  });

  @override
  State<StatefulWidget> createState() => _ScrollScaffoldWidgetState();

}

class _ScrollScaffoldWidgetState extends State<ScrollScaffoldWidget> {

  @override
  Widget build(BuildContext context) {

    return PlatformScaffold(
      backgroundColor: Colors.white,
      body: Builder(
          builder: (BuildContext innerContext) {
            widget._baseScaffoldService.scaffoldContext = innerContext;
            return BaseWidget(
                builder: (baseContext, sizingInfo) {
                  return SingleChildScrollView(
                    child: Container(
                      constraints: BoxConstraints(
                        minHeight: sizingInfo.localWidgetSize.height,
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            BaseWidget(
                              builder: widget.childBuilder,
                            ),
                          ],
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