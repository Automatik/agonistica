import 'dart:collection';

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/team_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:agonistica/views/players/players_view.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoriesViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  Menu _currentMenu;
  List<SeasonTeam> _seasonTeams;
  SplayTreeSet<Season> _sortedSeasons;
  SplayTreeSet<Category> _sortedCategories;

  CategoriesViewModel(List<String> menuCategoriesIds) {
    _seasonTeams = [];
    _sortedSeasons = SplayTreeSet((s1, s2) => Season.compare(s1, s2));
    _sortedCategories = SplayTreeSet((c1, c2) => Category.compare(c1, c2));
    loadItems(menuCategoriesIds);
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems(List<String> menuCategoriesIds) async {
    setBusy(true);
    //Write your models loading codes here

    _currentMenu = _appStateService.selectedMenu;
    if(_currentMenu.isTeamMenu()) {
      await _getTeamSeasons(_currentMenu);
      Season lastSeason = _getFirstSeasonItem();
      await _getTeamCategories(_seasonTeams, lastSeason.id);
    } else {
      await _getPlayersSeasons();
      await _getPlayersCategories(_currentMenu);
    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  Future<void> _getTeamSeasons(Menu menu) async {
    Team team = await _databaseService.teamService.getItemById(menu.teamId);
    _seasonTeams = await _databaseService.seasonTeamService.getItemsByIds(team.seasonTeamsIds);
    List<String> teamSeasonsIds = _seasonTeams.map((e) => e.seasonId).toList();
    List<Season> teamSeasons = await _databaseService.seasonService.getUniqueSeasonsFromIds(teamSeasonsIds);
    await _mergeSeasons(teamSeasons);
  }

  Future<void> _getTeamCategories(List<SeasonTeam> seasonTeams, String seasonId) async {
    SeasonTeam seasonTeam = seasonTeams.firstWhere((st) => st.seasonId == seasonId);
    List<Category> categories = await _databaseService.categoryService.getItemsByIds(seasonTeam.categoriesIds);
    _sortedCategories.addAll(categories);
  }

  Future<void> _getPlayersSeasons() async {
    FollowedPlayers followedPlayers = await _databaseService.followedPlayersService.getFollowedPlayers();
    List<Player> allPlayers = await _databaseService.playerService.getItemsByIds(followedPlayers.playersIds);
    List<SeasonPlayer> allSeasonPlayers = await _databaseService.seasonPlayerService.getSeasonPlayersFromPlayers(allPlayers);
    List<String> allSeasonsIds = allSeasonPlayers.map((e) => e.seasonId).toList();
    List<Season> seasons = await _databaseService.seasonService.getUniqueSeasonsFromIds(allSeasonsIds);
    await _mergeSeasons(seasons);
  }

  Future<void> _getPlayersCategories(Menu menu) async {
    List<Category> menuCategories = await _databaseService.categoryService.getItemsByIds(menu.categoriesIds);
    _sortedCategories.addAll(menuCategories);
  }

  Future<void> _mergeSeasons(List<Season> seasons) async {
    Season currentSeason = await _databaseService.seasonService.getCurrentSeason();
    // merge seasons
    _sortedSeasons.addAll(seasons);
    _sortedSeasons.add(currentSeason);
  }

  String getAppBarTitle() {
    return _baseScaffoldService.teamSelected;
  }

  int getCategoriesCount() {
    return _sortedCategories.length;
  }

  String getCategory(int index) {
    if(index < 0 || index >= _sortedCategories.length)
      return "";
    return _sortedCategories.elementAt(index).name;
  }

  List<String> getSeasonPeriods() {
    return _getReversedSeasons().map((e) => e.period).toList();
  }

  Season _getFirstSeasonItem() {
    return _getSeasonItemAtIndex(0);
  }

  Season _getSeasonItemAtIndex(int index) {
    return _getReversedSeasons().elementAt(index);
  }

  /// reverse list to show as first item the latest season
  List<Season> _getReversedSeasons() {
    return _sortedSeasons.toList().reversed.toList();
  }

  Future<void> onSeasonItemChanged(int index) async {
    Season selectedSeason = _getSeasonItemAtIndex(index);
    _sortedCategories.clear();
    if(_currentMenu.isTeamMenu()) {
      await _getTeamCategories(_seasonTeams, selectedSeason.id);
    } else {
      await _getPlayersCategories(_currentMenu);
    }
    notifyListeners();
  }

  void onCategoryTap(BuildContext context, int index) {
    _appStateService.selectedCategory = _sortedCategories.elementAt(index);
    Menu menu = _appStateService.selectedMenu;
    if(menu.isTeamMenu()) {
      Navigator.pushNamed(
          context,
          TeamView.routeName,
          arguments: TeamViewArguments(TabScaffoldWidget.MATCHES_VIEW_INDEX)
      );
      return;
    }
    if(menu.isPlayersMenu()) {
      Navigator.pushNamed(
          context,
          PlayersView.routeName,
      );
      return;
    }
  }

  Future<void> onCategoryLongTap(int index) async {
    Category category = _sortedCategories.elementAt(index);
    await _databaseService.categoryService.deleteItem(category.id);
    _appStateService.selectedMenu.categoriesIds.remove(category.id);
    // update view
    notifyListeners();
  }

  /// Check if no other category exist with this name (within that menu)
  String validateNewCategory(String categoryName) {
    String validationResult = InputValidation.validateCategoryName(categoryName);
    if(validationResult != null) {
      // not valid
      return validationResult;
    }
    List<String> categories = _sortedCategories.map((e) => e.name);
    bool categoryAlreadyExists = categories.contains(categoryName);
    if(categoryAlreadyExists) {
      return "Categoria esiste già";
    }
    return null; //Everything ok
  }

  Future<void> createNewCategory(String categoryName) async {
    Category category = Category.name(categoryName);
    await _databaseService.menuService.addCategoryToMenu(category, _appStateService.selectedMenu);
    _sortedCategories.add(category);
    notifyListeners();
  }

}