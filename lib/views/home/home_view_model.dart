import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/core/utils/my_strings.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  static Logger _logger = getLogger('HomeViewModel');

  HomeMenus _homeMenus;

  HomeViewModel(){
    _homeMenus = HomeMenus();
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    _homeMenus = await _databaseService.getHomeMenus();

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getAppBarTitle() {
    return MyStrings.HOME_VIEW_APP_BAR_TITLE;
  }

  int getFollowedTeamsMenusSize() {
    return _homeMenus.getFollowedTeamsMenus().size();
  }

  int getFollowedPlayersMenusSize() {
    return _homeMenus.getFollowedPlayersMenus().size();
  }

  Menu getFollowedTeamMenu(int index) {
    return _homeMenus.getFollowedTeamsMenus().elementAt(index);
  }

  Menu getFollowedPlayerMenu(int index) {
    return _homeMenus.getFollowedPlayersMenus().elementAt(index);
  }

  Future<void> onFollowedTeamMenuTap(BuildContext context, int index) async {
    Menu menu = getFollowedTeamMenu(index);
    _appStateService.selectFollowedTeamMenu(context, menu);
  }

  Future<void> onFollowedPlayerMenuTap(BuildContext context, int index) async {
    Menu menu = getFollowedPlayerMenu(index);
    _appStateService.selectFollowedPlayersMenu(context, menu);
  }

  void setAppBarTitle(String name) {
    _baseScaffoldService.teamSelected = name;
  }

  Future<void> navigateToCategoriesView(BuildContext context, List<String> categoriesIds) async {
    await Navigator.pushNamed(
      context,
      CategoriesView.routeName,
      arguments: CategoriesViewArguments(categoriesIds),
    );
  }

}