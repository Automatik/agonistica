import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/colors/app_color.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:agonistica/widgets/base/base_widget.dart';
import 'package:agonistica/widgets/drawers/custom_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class ScrollScaffoldWidget extends StatefulWidget {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final _databaseService = locator<DatabaseService>();

  final Widget Function(BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) childBuilder;
  final String title;
  final BasePlatformAppBar platformAppBar;
  final bool showAppBar;

  ScrollScaffoldWidget({
    this.childBuilder,
    this.title = defaultAppBarTitle,
    this.platformAppBar,
    this.showAppBar = true,
  });

  @override
  State<StatefulWidget> createState() => _ScrollScaffoldWidgetState();

}

class _ScrollScaffoldWidgetState extends State<ScrollScaffoldWidget> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeMenus>(
      future: getHomeMenus(),
      builder: (BuildContext futureContext, AsyncSnapshot<HomeMenus> snapshot) {
        HomeMenus homeMenus = snapshot.hasData ? snapshot.data : HomeMenus();
        return scaffold(context, homeMenus);
      }
    );
  }

  Widget scaffold(BuildContext context, HomeMenus homeMenus) {
    return PlatformScaffold(
      appBar: chooseAppBar(),
      backgroundColor: AppColor.getScaffoldBackground(),
      material: (materialScaffoldContext, __) => MaterialScaffoldData(
        drawer: CustomDrawer(
          homeMenus: homeMenus,
          onFollowedTeamsMenuTap: (menu) => locator<AppStateService>().selectFollowedTeamMenu(context, menu),
          onFollowedPlayersMenuTap: (menu) => locator<AppStateService>().selectFollowedPlayersMenu(context, menu),
        ),
      ),
      body: Builder(
          builder: (BuildContext innerContext) {
            widget._baseScaffoldService.scaffoldContext = innerContext;
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

  Widget chooseAppBar() {
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

  Future<HomeMenus> getHomeMenus() async {
    return await widget._databaseService.getHomeMenus();
  }

}