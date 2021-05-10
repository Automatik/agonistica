import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/app_background.dart';
import 'package:agonistica/core/shared/my_sizing_information.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:agonistica/widgets/base/base_widget.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabScaffoldWidget extends StatefulWidget {

  static const int MATCHES_VIEW_INDEX = 0;
  static const int ROSTER_VIEW_INDEX = 1;

  final _baseScaffoldService = locator<BaseScaffoldService>();

  final Widget Function(BuildContext context, MySizingInformation sizingInformation, MySizingInformation parentSizingInformation) childBuilder;
  final String title;
  final int initialIndex;
  final PlatformAppBar platformAppBar;
  final Function(int) onBottomItemChanged;

  final double iconsSize = 24;

  TabScaffoldWidget({
    this.title,
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
      appBarBuilder: (_, index) => widget.platformAppBar ?? BasePlatformAppBar(title: widget.title),
      pageBackgroundColor: AppBackground.getScaffoldBackground(),
      bodyBuilder: (_, index) {
        // Use a nested builder to get a context inside the Scaffold used then by the snackBars
        return Builder(
          builder: (innerContext) {
            widget._baseScaffoldService.scaffoldContext = innerContext;
            return Container(
              decoration: BoxDecoration(
                gradient: AppBackground.getBackground(),
              ),
              child: BaseWidget(
                builder: widget.childBuilder,
              ),
            );
          },
        );
      },
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
              IconAssets.ICON_FOOTBALL_BALL,
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