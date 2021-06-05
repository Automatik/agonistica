import 'dart:collection';

import 'package:agonistica/core/app_services/app_state_service.dart';
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

  SplayTreeSet<Match> _sortedMatches;
  SplayTreeSet<SeasonPlayer> _sortedSeasonPlayers;

  TeamViewModel(){
    _sortedMatches = SplayTreeSet((m1, m2) => Match.compare(m1, m2));
    _sortedSeasonPlayers = SplayTreeSet((sp1, sp2) => SeasonPlayer.compare(sp1, sp2));

    loadItems();
  }

  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    SeasonTeam seasonTeam = _appStateService.selectedSeasonTeam;
    Category category = _appStateService.selectedCategory;

    if(seasonTeam == null || category == null)
      _logger.d("selectedSeasonTeam or selectedCategory is null");
    else {
      _logger.d("Loading matches and players...");
      List<Match> matches = await _databaseService.matchService.getTeamMatchesByCategory(seasonTeam, category);
      matches = await _databaseService.matchService.completeMatchesWithMissingInfo(matches);
      _logger.d("matches size: ${matches.length}");

      List<SeasonPlayer> seasonPlayers = await _databaseService.seasonPlayerService.getSeasonPlayersByTeamAndCategory(seasonTeam.id, category.id);
      // set player's team name and category name
      seasonPlayers = await _databaseService.seasonPlayerService.completeSeasonPlayersWithMissingInfo(seasonPlayers);

      _sortedMatches.addAll(matches);
      _sortedSeasonPlayers.addAll(seasonPlayers);
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
    if(_sortedSeasonPlayers == null) {
      _logger.d("players list is null");
      return;
    }

    // check if player's id is already in players list
    // meaning the player is updated
    SeasonPlayer player = _sortedSeasonPlayers.firstWhere((sp) => sp.id == seasonPlayer.id, orElse: () => null);
    if(player != null) {
      // check if the player's team or category has changed
      if(seasonPlayer.seasonTeamId != _appStateService.selectedTeam.id || seasonPlayer.categoryId != _appStateService.selectedCategory.id) {
        // remove the player from the players list
        _sortedSeasonPlayers.removeWhere((sp) => sp.id == seasonPlayer.id);
      } else {
        // otherwise update the players list
        _sortedSeasonPlayers.removeWhere((sp) => sp.id == seasonPlayer.id);
        _sortedSeasonPlayers.add(seasonPlayer);
      }
      _logger.d("player updated in list");
    } else {
      // otherwise it's a new player
      _sortedSeasonPlayers.add(seasonPlayer);
      _logger.d("new player added to list");
    }



    _updateView();
  }

  void _onMatchDetailUpdate(Match match) {
    _logger.d("TeamViewModel/onMatchDetailUpdate");
    if(_sortedMatches == null) {
      _logger.d("matches list is null");
      return;
    }
    _sortedMatches.removeWhere((m) => m.id == match.id);
    _sortedMatches.add(match);
    _updateView();
  }

  String getWidgetTitle() {
    return _appStateService.selectedCategory.name;
  }

  int getMatchesSize() {
    return _sortedMatches.length;
  }

  int getSeasonPlayersSize() {
    return _sortedSeasonPlayers.length;
  }

  Match getMatch(int index) {
    return _sortedMatches.elementAt(index);
  }

  SeasonPlayer getSeasonPlayers(int index) {
    return _sortedSeasonPlayers.elementAt(index);
  }

  Future<void> openMatchDetail(BuildContext context, int index) async {
    if(_sortedMatches == null || _sortedMatches.isEmpty) {
      _logger.d("Matches is null or empty when calling deleteMatch");
      return;
    }
    Match match = _sortedMatches.elementAt(index);
    NavUtils.navToMatchDetail(context, match, _onMatchDetailUpdate);
  }

  Future<void> openPlayerDetail(BuildContext context, int index) async {
    if(_sortedSeasonPlayers == null || _sortedSeasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = _sortedSeasonPlayers.elementAt(index);
    NavUtils.navToPlayerDetail(context, seasonPlayer, _onPlayerDetailUpdate);
  }

  Future<void> addNewMatch(BuildContext context) async {
    String categoryId = _appStateService.selectedCategory.id;
    String seasonId = _appStateService.selectedSeason.id;
    String team1ImageFilename = await _databaseService.getNewTeamImage();
    String team2ImageFilename = await _databaseService.getNewTeamImage();
    NavUtils.navToNewMatch(context, categoryId, seasonId, team1ImageFilename, team2ImageFilename, _onMatchDetailUpdate);
  }

  Future<void> addNewPlayer(BuildContext context) async {
    SeasonTeam seasonTeam = _appStateService.selectedSeasonTeam;
    Category category = _appStateService.selectedCategory;
    NavUtils.navToNewPlayer(context, seasonTeam, category, _onPlayerDetailUpdate);
  }

  Future<void> deleteMatch(int index) async {
    if(_sortedMatches == null || _sortedMatches.isEmpty) {
      _logger.d("Matches is null or empty when calling deleteMatch");
      return;
    }
    Match match = _sortedMatches.elementAt(index);
    _sortedMatches.removeWhere((element) => element.id == match.id);
    await _databaseService.matchService.deleteItem(match.id);
    _updateView();
  }

  Future<void> deletePlayer(int index) async {
    if(_sortedSeasonPlayers == null || _sortedSeasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = _sortedSeasonPlayers.elementAt(index);
    _sortedSeasonPlayers.removeWhere((element) => element.id == seasonPlayer.id);
    await _databaseService.seasonPlayerService.deleteItem(seasonPlayer.id);
    _updateView();
  }


}