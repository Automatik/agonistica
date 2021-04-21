import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  static Logger _logger = getLogger('HomeViewModel');


  Menu _mainMenu;
  List<Menu> _otherMenus = [];

  HomeViewModel(){
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    _mainMenu = await _databaseService.menuService.getMainMenu();
    _otherMenus = await _databaseService.menuService.getOtherMenus();

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getMainMenuName() {
    return _mainMenu == null ? "" : _mainMenu.name;
  }

  int getOtherMenusCount() {
    return _otherMenus.length;
  }

  String getOtherMenuName(int index) {
    if(index < getOtherMenusCount()) {
      return _otherMenus[index].name;
    }
    return "";
  }

  Future<void> onMainButtonTap(BuildContext context) async {
    setAppBarTitle(_mainMenu.name);
    // Get the team corresponding to this menu
    Team team = await _databaseService.teamService.getItemById(_mainMenu.teamId);
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

  Future<void> onOtherPlayersTap(BuildContext context, int index) async {
    Menu menu = _otherMenus[index];
    setAppBarTitle(menu.name);

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