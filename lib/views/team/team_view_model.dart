import 'package:agonistica/core/arguments/MatchesViewArguments.dart';
import 'package:agonistica/core/arguments/RosterViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class TeamViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  static Logger _logger = getLogger('TeamViewModel');

  List<Match> matches;
  List<Player> players;

  TeamViewModel(){
    matches = [];
    players = [];

    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    if(_databaseService.selectedTeam == null || _databaseService.selectedCategory == null)
      _logger.d("selectedTeam or selectedCategory is null");
    else {
      _logger.d("Loading matches and players...");
      matches = await _databaseService.getTeamMatchesByCategory(
          _databaseService.selectedTeam, _databaseService.selectedCategory);

      print("matches size: ${matches.length}");
      matches = await _databaseService.completeMatchesWithMissingInfo(matches);

      players = await _databaseService.getPlayersByTeamAndCategory(_databaseService.selectedTeam.id,
          _databaseService.selectedCategory.id);
      // set player's team name and category name
      for(Player player in players) {
        player.setTeam(_databaseService.selectedTeam);
        player.setCategory(_databaseService.selectedCategory);
      }

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
  void _onPlayerDetailUpdate(Player player) {
    if(players == null) {
      _logger.d("players list is null");
      return;
    }

    // check if player's id is already in players list
    // meaning the player is updated
    int index = players.indexWhere((p) => p.id == player.id);
    if(index != -1) {

      // check if the player's team or category has changed
      if(player.seasonTeamId != _databaseService.selectedTeam.id || player.categoryId != _databaseService.selectedCategory.id) {
        // remove the player from the players list
        players.removeAt(index);
      } else {
        // otherwise update the players list
        players[index] = player;
      }
      _logger.d("player updated in list");
    } else {
      // otherwise it's a new player
      players.add(player);
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
    return _databaseService.selectedCategory.name;
  }

  Future<void> openMatchDetail(BuildContext context, int index) async {
    if(matches == null || matches.isEmpty) {
      _logger.d("Matches is null or empty when calling deleteMatch");
      return;
    }
    Match match = matches[index];
    bool isNewMatch = false;
    NavUtils.navToMatchesView(context, MatchesViewArguments(isNewMatch, match, _onMatchDetailUpdate));
  }

  Future<void> openPlayerDetail(BuildContext context, int index) async {
    if(players == null || players.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    Player player = players[index];
    bool isNewPlayer = false;
    NavUtils.navToRosterView(context, RosterViewArguments(isNewPlayer, player, _onPlayerDetailUpdate));
  }

  Future<void> addNewMatch(BuildContext context) async {
    bool isNewMatch = true;
    Match match = Match.empty();
    match.categoryId = _databaseService.selectedCategory.id;
    NavUtils.navToMatchesView(context, MatchesViewArguments(isNewMatch, match, _onMatchDetailUpdate));
  }

  Future<void> addNewPlayer(BuildContext context) async {
    bool isNewPlayer = true;
    Player player = Player.empty();
    player.setCategory(_databaseService.selectedCategory);
    player.setTeam(_databaseService.selectedTeam);
    NavUtils.navToRosterView(context, RosterViewArguments(isNewPlayer, player, _onPlayerDetailUpdate));
  }

  Future<void> deleteMatch(int index) async {
    if(matches == null || matches.isEmpty) {
      _logger.d("Matches is null or empty when calling deleteMatch");
      return;
    }
    Match match = matches.removeAt(index);
    await _databaseService.deleteMatch(match.id);
    _updateView();
  }

  Future<void> deletePlayer(int index) async {
    if(players == null || players.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    Player player = players.removeAt(index);
    await _databaseService.deletePlayer(player.id);
    _updateView();
  }


}