import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabScaffoldWidget extends StatefulWidget {

  static const int MATCHES_VIEW_INDEX = 0;
  static const int ROSTER_VIEW_INDEX = 1;

  final Widget Function(BuildContext context, MySizingInformation sizingInformation) childBuilder;
  final String title;
  final bool showAppBar;
  final int initialIndex;
  final PlatformAppBar platformAppBar;
  final Function(int) onBottomItemChanged;

  final double iconsSize = 24;

  TabScaffoldWidget({
    this.title,
    this.showAppBar,
    this.initialIndex,
    this.platformAppBar,
    this.childBuilder,
    this.onBottomItemChanged,
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
        initialIndex: widget.initialIndex ?? TabScaffoldWidget.MATCHES_VIEW_INDEX,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PlatformTabScaffold(
      tabController: _tabController,
      currentIndex: _tabController.index(context),
      appBarBuilder: (_, index) => widget.platformAppBar ?? Utils.getPlatformAppBar(widget.title),
      bodyBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [blueLightAgonisticaColor, blueAgonisticaColor],
          ),
        ),
        child: BaseWidget(
          builder: widget.childBuilder,
        ),
      ),
      itemChanged: (index) {
        widget.onBottomItemChanged.call(index);
      },
      tabsBackgroundColor: appBarBackgroundColor,
      materialTabs: (_ , __) => MaterialNavBarData(
        selectedItemColor: blueAgonisticaColor,
        unselectedItemColor: textDisabledColor,
        items: [
          BottomNavigationBarItem(
            label: 'Partite',
            icon: SvgPicture.asset(
              'assets/images/010-football.svg',
              color: isMatchesViewSelected(context) ? blueAgonisticaColor : textDisabledColor,
              width: widget.iconsSize,
              height: widget.iconsSize,
            ),
          ),
          BottomNavigationBarItem(
            label: 'Rosa',
            icon: Icon(context.platformIcons.group, size: widget.iconsSize,)
          )
        ]
      ),
    );
  }

  bool isMatchesViewSelected(BuildContext context) {
    return _tabController.index(context) == TabScaffoldWidget.MATCHES_VIEW_INDEX;
  }

}