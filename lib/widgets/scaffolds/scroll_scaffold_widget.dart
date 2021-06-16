import 'package:agonistica/core/colors/app_color.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:agonistica/widgets/base/base_widget.dart';
import 'package:agonistica/widgets/scaffolds/base_scaffold_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ScrollScaffoldWidget extends BaseScaffoldWidget {
  final bool showAppBar;

  ScrollScaffoldWidget({
    childBuilder,
    title = defaultAppBarTitle,
    platformAppBar,
    this.showAppBar = true,
  }) : super(childBuilder: childBuilder, title: title, platformAppBar: platformAppBar);

  @override
  State<StatefulWidget> createState() => _ScrollScaffoldWidgetState();

}

class _ScrollScaffoldWidgetState extends BaseScaffoldWidgetState<ScrollScaffoldWidget> {

  Widget scaffold(BuildContext context, HomeMenus homeMenus) {
    return PlatformScaffold(
      appBar: chooseAppBar(),
      backgroundColor: AppColor.getScaffoldBackground(),
      material: (_, __) => MaterialScaffoldData(
        drawer: getDrawer(homeMenus)
      ),
      body: Builder(
          builder: (BuildContext innerContext) {
            widget.baseScaffoldService!.scaffoldContext = innerContext;
            return BaseWidget(
                builder: (baseContext, sizingInfo, parentSizingInfo) {
                  return SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: AppColor.getBackground(),
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

  PlatformAppBar? chooseAppBar() {
    if(!widget.showAppBar) {
      return null;
    }
    if(widget.platformAppBar != null) {
      return widget.platformAppBar;
    }
    if(widget.title != null) {
      return BasePlatformAppBar(
        title: widget.title,
      );
    }
    return null;
  }

}