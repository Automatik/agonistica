import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/drawers/custom_drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

abstract class BaseScaffoldWidget extends StatefulWidget {

  final BaseScaffoldService? baseScaffoldService = locator<BaseScaffoldService>();
  final DatabaseService? _databaseService = locator<DatabaseService>();

  final Widget Function(BuildContext context, MySizingInformation sizingInformation, MySizingInformation? parentSizingInformation) childBuilder;
  final String? title;
  final PlatformAppBar? platformAppBar;

  BaseScaffoldWidget({
    required this.childBuilder,
    this.title = defaultAppBarTitle,
    this.platformAppBar,
  });

}

abstract class BaseScaffoldWidgetState<T extends BaseScaffoldWidget> extends State<T> {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HomeMenus>(
        future: getHomeMenus(),
        builder: (BuildContext futureContext, AsyncSnapshot<HomeMenus> snapshot) {
          HomeMenus homeMenus = snapshot.hasData ? snapshot.data! : HomeMenus();
          return scaffold(context, homeMenus);
        }
    );
  }

  Widget scaffold(BuildContext context, HomeMenus homeMenus);

  Future<HomeMenus> getHomeMenus() async {
    return await widget._databaseService!.getHomeMenus();
  }

  CustomDrawer getDrawer(HomeMenus homeMenus) {
    return CustomDrawer(
      homeMenus: homeMenus,
      onFollowedTeamsMenuTap: (menu) => locator<AppStateService>().selectFollowedTeamMenu(context, menu),
      onFollowedPlayersMenuTap: (menu) => locator<AppStateService>().selectFollowedPlayersMenu(context, menu),
    );
  }

}