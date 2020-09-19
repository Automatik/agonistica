import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabScaffoldWidget extends StatefulWidget {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final Widget Function(BuildContext context, MySizingInformation sizingInformation) childBuilder;
  final String title;
  final bool showAppBar;

  TabScaffoldWidget({
    this.title,
    this.showAppBar,
    this.childBuilder,
  });

  @override
  State<StatefulWidget> createState() => _TabScaffoldWidgetState();

}

class _TabScaffoldWidgetState extends State<TabScaffoldWidget> {

  PlatformTabController _tabController;

  @override
  void initState() {
    super.initState();
    if(_tabController == null) {
      _tabController = PlatformTabController(
        initialIndex: 1,
      );
    }
    widget._baseScaffoldService.bottomBarSelectedIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: _tabController,
      currentIndex: _tabController.index(context),
      appBarBuilder: (_, index) => Utils.getPlatformAppBar(widget.title),
      bodyBuilder: (context, index) => BaseWidget(
        builder: widget.childBuilder,
      ),
      itemChanged: (index) {
        widget._baseScaffoldService.bottomBarSelectedIndex = index;
      },
      tabsBackgroundColor: appBarBackgroundColor,
      materialTabs: (_ , __) => MaterialNavBarData(
        selectedItemColor: blueAgonisticaColor,
        unselectedItemColor: textDisabledColor,
        items: [
          BottomNavigationBarItem(
            title: Text(
              'Partite',
              textAlign: TextAlign.center,
            ),
            icon: SvgPicture.asset(
              'assets/images/010-football.svg',
//              color: blueAgonisticaColor,
            ),
          ),
          BottomNavigationBarItem(
            title: Text(
              'Rosa',
              textAlign: TextAlign.center,
            ),
            icon: Icon(context.platformIcons.group)
          )
        ]
      ),
    );
  }

}