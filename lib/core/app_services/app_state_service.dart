import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/app_user.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:flutter/material.dart';

import 'base_scaffold_service.dart';
import 'database_service.dart';

class AppStateService {

  late Menu selectedMenu;
  late Team selectedTeam;
  late Category selectedCategory;
  late SeasonTeam selectedSeasonTeam;
  late Season selectedSeason;
  late AppUser selectedAppUser;

  bool isTeamMenu() {
    return selectedMenu.type == Menu.TYPE_FOLLOWED_TEAMS;
  }

  bool isPlayersMenu() {
    return selectedMenu.type == Menu.TYPE_FOLLOWED_PLAYERS;
  }

  /// Navigate to the season team of the current season
  Future<void> selectFollowedTeamMenu(BuildContext context, Menu menu) async {
    final _databaseService = locator<DatabaseService>();
    _setAppBarTitle(menu.name);
    // Set menu selected
    selectedMenu = menu;
    // Get the team corresponding to this menu
    Team team = await _databaseService.teamService.getItemById(menu.teamId!);
    selectedTeam = team;
    SeasonTeam seasonTeam;
    bool currentSeasonTeamExists = await _databaseService.seasonTeamService.currentSeasonTeamExists(team.id!);
    if(currentSeasonTeamExists) {
      // Get the current season team
      seasonTeam = await _databaseService.seasonTeamService
          .getCurrentSeasonTeamFromIds(team.seasonTeamsIds);
    } else {
      // Create the current season team and save it
      Season season = await _databaseService.seasonService.getCurrentSeason();
      seasonTeam = SeasonTeam.empty(team.id!, season.id);
      await _databaseService.seasonTeamService.saveItem(seasonTeam);
    }
    seasonTeam.team = team;
    selectedSeasonTeam = seasonTeam;
    selectedSeason = await _databaseService.seasonService.getItemById(seasonTeam.seasonId);
    // Get season team's categories
    List<String> categoriesIds = seasonTeam.categoriesIds;
    _navigateToCategoriesView(context, categoriesIds);
  }

  Future<void> selectFollowedPlayersMenu(BuildContext context, Menu menu) async {
    final _databaseService = locator<DatabaseService>();
    _setAppBarTitle(menu.name);
    // Set menu selected
    selectedMenu = menu;

    // Get the current season
    selectedSeason = await _databaseService.seasonService.getCurrentSeason();
    _navigateToCategoriesView(context, menu.categoriesIds as List<String>);
  }

  void _setAppBarTitle(String? name) {
    final _baseScaffoldService = locator<BaseScaffoldService>();
    _baseScaffoldService.teamSelected = name;
  }

  Future<void> _navigateToCategoriesView(BuildContext context, List<String> categoriesIds) async {
    await NavUtils.navToCategoriesView(context, categoriesIds);
  }

}