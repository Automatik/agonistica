import 'dart:collection';

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
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

  SplayTreeSet<Menu> _sortedFollowedTeamsMenus;
  SplayTreeSet<Menu> _sortedFollowedPlayersMenus;

  HomeViewModel(){
    _sortedFollowedTeamsMenus = SplayTreeSet((m1, m2) => Menu.compare(m1, m2));
    _sortedFollowedPlayersMenus = SplayTreeSet((m1, m2) => Menu.compare(m1, m2));
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    List<Menu> followedTeamsMenus = await _databaseService.menuService.getFollowedTeamsMenus();
    List<Menu> followedPlayersMenus = await _databaseService.menuService.getFollowedPlayersMenus();

    _sortedFollowedTeamsMenus.addAll(followedTeamsMenus);
    _sortedFollowedPlayersMenus.addAll(followedPlayersMenus);

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getAppBarTitle() {
    return MyStrings.HOME_VIEW_APP_BAR_TITLE;
  }

  int getFollowedTeamsMenusSize() {
    return _sortedFollowedTeamsMenus.length;
  }

  int getFollowedPlayersMenusSize() {
    return _sortedFollowedPlayersMenus.length;
  }

  Menu getFollowedTeamMenu(int index) {
    return _sortedFollowedTeamsMenus.elementAt(index);
  }

  Menu getFollowedPlayerMenu(int index) {
    return _sortedFollowedPlayersMenus.elementAt(index);
  }

  Future<void> onFollowedTeamMenuTap(BuildContext context, int index) async {
    Menu menu = getFollowedTeamMenu(index);
    setAppBarTitle(menu.name);
    // Set menu selected
    _appStateService.selectedMenu = menu;
    // Get the team corresponding to this menu
    Team team = await _databaseService.teamService.getItemById(menu.teamId);
    _appStateService.selectedTeam = team;
    // Get the current season team
    SeasonTeam seasonTeam = await _databaseService.seasonTeamService.getCurrentSeasonTeamFromIds(team.seasonTeamsIds);
    seasonTeam.team = team;
    _appStateService.selectedSeasonTeam = seasonTeam;
    _appStateService.selectedSeason = await _databaseService.seasonService.getItemById(seasonTeam.seasonId);
    // Get season team's categories
    List<String> categoriesIds = seasonTeam.categoriesIds;
    navigateToCategoriesView(context, categoriesIds);
  }

  Future<void> onFollowedPlayerMenuTap(BuildContext context, int index) async {
    Menu menu = getFollowedPlayerMenu(index);
    setAppBarTitle(menu.name);
    // Set menu selected
    _appStateService.selectedMenu = menu;

    // Get the current season
    _appStateService.selectedSeason = await _databaseService.seasonService.getCurrentSeason();
    navigateToCategoriesView(context, menu.categoriesIds);
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