// @dart=2.9

import 'package:agonistica/core/colors/app_color.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/my_strings.dart';
import 'package:agonistica/widgets/text_styles/drawer_header_style.dart';
import 'package:agonistica/widgets/text_styles/drawer_item_header_style.dart';
import 'package:agonistica/widgets/text_styles/drawer_item_style.dart';
import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {

  final HomeMenus homeMenus;
  final Function(Menu) onFollowedTeamsMenuTap;
  final Function(Menu) onFollowedPlayersMenuTap;

  CustomDrawer({
    @required this.homeMenus,
    this.onFollowedTeamsMenuTap,
    this.onFollowedPlayersMenuTap
  }) : assert(homeMenus != null);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: drawerWidgets(context),
      ),
    );
  }

  List<Widget> drawerWidgets(BuildContext context) {
    List<Widget> widgets = [];
    widgets.add(drawerHeader());
    widgets.add(drawerItemHeader(MyStrings.HOME_VIEW_TITLE_FOLLOWED_TEAMS));
    widgets.addAll(drawerItems(context, homeMenus.getFollowedTeamsMenusList(), onFollowedTeamsMenuTap));
    widgets.add(drawerItemHeader(MyStrings.HOME_VIEW_TITLE_FOLLOWED_PLAYERS));
    widgets.addAll(drawerItems(context, homeMenus.getFollowedPlayersMenusList(), onFollowedPlayersMenuTap));
    return widgets;
  }

  Widget drawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: AppColor.getBackground(),
      ),
      child: Text(
        defaultAppBarTitle,
        style: DrawerHeaderStyle(),
      )
    );
  }

  Widget drawerItemHeader(String text) {
    return ListTile(
      title: Text(
        text,
        textAlign: TextAlign.start,
        style: DrawerItemHeaderStyle(),
      ),
    );
  }

  List<Widget> drawerItems(BuildContext context, List<Menu> menus, Function(Menu) onItemTap) {
    List<Widget> widgets = menus.map((m) {
      return Container(
        padding: const EdgeInsets.only(left: 15),
        child: ListTile(
          title: Text(
            m.name,
            textAlign: TextAlign.start,
            style: DrawerItemStyle(),
          ),
          onTap: () {
            if(onItemTap != null) {
              onItemTap(m);
            }
            // close drawer
            Navigator.pop(context);
            },
        ),
      );
    }).toList();
    return widgets;
  }

}