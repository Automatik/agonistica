import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/pojo/sorted_menu_list.dart';

class HomeMenus {

  late SortedMenuList _followedTeamsMenus;
  late SortedMenuList _followedPlayersMenus;

  HomeMenus() {
    _followedTeamsMenus = SortedMenuList();
    _followedPlayersMenus = SortedMenuList();
  }

  factory HomeMenus.from(List<Menu> menus1, List<Menu> menus2) {
    HomeMenus homeMenus = HomeMenus();
    homeMenus._followedTeamsMenus = SortedMenuList.from(menus1);
    homeMenus._followedPlayersMenus = SortedMenuList.from(menus2);
    return homeMenus;
  }

  void addFollowedTeamMenu(Menu menu) {
    _followedTeamsMenus.add(menu);
  }

  void addFollowedPlayersMenu(Menu menu) {
    _followedPlayersMenus.add(menu);
  }

  SortedMenuList? getFollowedTeamsMenus() {
    return _followedTeamsMenus;
  }

  SortedMenuList? getFollowedPlayersMenus() {
    return _followedPlayersMenus;
  }

  List<Menu> getFollowedTeamsMenusList() {
    return _followedTeamsMenus.toList();
  }

  List<Menu> getFollowedPlayersMenusList() {
    return _followedPlayersMenus.toList();
  }

}