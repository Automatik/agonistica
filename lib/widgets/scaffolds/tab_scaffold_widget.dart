// @dart=2.9

import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/colors/app_color.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/widgets/app_bars/base_platform_app_bar.dart';
import 'package:agonistica/widgets/base/base_widget.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/scaffolds/base_scaffold_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabScaffoldWidget extends BaseScaffoldWidget {

  static const int MATCHES_VIEW_INDEX = 0;
  static const int ROSTER_VIEW_INDEX = 1;

  final int initialIndex;
  final Function(int) onBottomItemChanged;

  final double iconsSize = 24;

  TabScaffoldWidget({
    title,
    this.initialIndex,
    platformAppBar,
    childBuilder,
    this.onBottomItemChanged,
  }) : super(childBuilder: childBuilder, title: title, platformAppBar: platformAppBar);

  @override
  State<StatefulWidget> createState() => _TabScaffoldWidgetState();

}

class _TabScaffoldWidgetState extends BaseScaffoldWidgetState<TabScaffoldWidget> {

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

  Widget scaffold(BuildContext context, HomeMenus homeMenus) {
    return PlatformTabScaffold(
      tabController: _tabController,
      appBarBuilder: (_, index) => widget.platformAppBar ?? BasePlatformAppBar(title: widget.title),
      pageBackgroundColor: AppColor.getScaffoldBackground(),
      material: (_, __) => MaterialTabScaffoldData(
        drawer: getDrawer(homeMenus),
      ),
      bodyBuilder: (_, index) {
        // Use a nested builder to get a context inside the Scaffold used then by the snackBars
        return Builder(
          builder: (innerContext) {
            widget.baseScaffoldService.scaffoldContext = innerContext;
            return Container(
              decoration: BoxDecoration(
                gradient: AppColor.getBackground(),
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