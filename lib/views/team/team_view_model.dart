import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/MatchesViewArguments.dart';
import 'package:agonistica/core/arguments/RosterViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class TeamViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  static Logger _logger = getLogger('TeamViewModel');

  List<Match> matches;
  List<SeasonPlayer> seasonPlayers;

  TeamViewModel(){
    matches = [];
    seasonPlayers = [];

    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    SeasonTeam seasonTeam = _appStateService.selectedSeasonTeam;
    Category category = _appStateService.selectedCategory;

    if(seasonTeam == null || category == null)
      _logger.d("selectedSeasonTeam or selectedCategory is null");
    else {
      _logger.d("Loading matches and players...");
      matches = await _databaseService.matchService.getTeamMatchesByCategory(seasonTeam, category);
      matches = await _databaseService.matchService.completeMatchesWithMissingInfo(matches);
      _logger.d("matches size: ${matches.length}");

      seasonPlayers = await _databaseService.seasonPlayerService.getSeasonPlayersByTeamAndCategory(seasonTeam.id, category.id);
      // set player's team name and category name
      seasonPlayers = await _databaseService.seasonPlayerService.completeSeasonPlayersWithMissingInfo(seasonPlayers);

    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  void _updateView() {
    notifyListeners();
  }

  /// Use this callback to update the players listView. When this method is
  /// executed, the player has been already saved
  void _onPlayerDetailUpdate(SeasonPlayer seasonPlayer) {
    if(seasonPlayers == null) {
      _logger.d("players list is null");
      return;
    }

    // check if player's id is already in players list
    // meaning the player is updated
    int index = seasonPlayers.indexWhere((p) => p.id == seasonPlayer.id);
    if(index != -1) {

      // check if the player's team or category has changed
      if(seasonPlayer.seasonTeamId != _appStateService.selectedTeam.id || seasonPlayer.categoryId != _appStateService.selectedCategory.id) {
        // remove the player from the players list
        seasonPlayers.removeAt(index);
      } else {
        // otherwise update the players list
        seasonPlayers[index] = seasonPlayer;
      }
      _logger.d("player updated in list");
    } else {
      // otherwise it's a new player
      seasonPlayers.add(seasonPlayer);
      _logger.d("new player added to list");
    }
    _updateView();
  }

  void _onMatchDetailUpdate(Match match) {
    _logger.d("TeamViewModel/onMatchDetailUpdate");
    if(matches == null) {
      _logger.d("matches list is null");
      return;
    }
    int index = matches.indexWhere((m) => m.id == match.id);
    if(index != -1) {
      matches[index] = match;
    } else {
      matches.add(match);
    }
    _updateView();
  }

  String getWidgetTitle() {
    return _appStateService.selectedCategory.name;
  }

  Future<void> openMatchDetail(BuildContext context, int index) async {
    if(matches == null || matches.isEmpty) {
      _logger.d("Matches is null or empty when calling deleteMatch");
      return;
    }
    Match match = matches[index];
    NavUtils.navToMatchDetail(context, match, _onMatchDetailUpdate);
  }

  Future<void> openPlayerDetail(BuildContext context, int index) async {
    if(seasonPlayers == null || seasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = seasonPlayers[index];
    NavUtils.navToPlayerDetail(context, seasonPlayer, _onPlayerDetailUpdate);
  }

  Future<void> addNewMatch(BuildContext context) async {
    String categoryId = _appStateService.selectedCategory.id;
    String seasonId = _appStateService.selectedSeason.id;
    NavUtils.navToNewMatch(context, categoryId, seasonId, _onMatchDetailUpdate);
  }

  Future<void> addNewPlayer(BuildContext context) async {
    SeasonTeam seasonTeam = _appStateService.selectedSeasonTeam;
    Category category = _appStateService.selectedCategory;
    NavUtils.navToNewPlayer(context, seasonTeam, category, _onPlayerDetailUpdate);
  }

  Future<void> deleteMatch(int index) async {
    if(matches == null || matches.isEmpty) {
      _logger.d("Matches is null or empty when calling deleteMatch");
      return;
    }
    Match match = matches.removeAt(index);
    await _databaseService.matchService.deleteItem(match.id);
    _updateView();
  }

  Future<void> deletePlayer(int index) async {
    if(seasonPlayers == null || seasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = seasonPlayers.removeAt(index);
    await _databaseService.seasonPlayerService.deleteItem(seasonPlayer.id);
    _updateView();
  }


}