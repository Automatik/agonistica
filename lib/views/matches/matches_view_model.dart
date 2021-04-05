import 'package:agonistica/core/arguments/RosterViewArguments.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class MatchesViewModel extends BaseViewModel {

  static Logger _logger = getLogger('MatchesViewModel');

  final bool isNewMatch;
  Match match;
  final Function(Match) onMatchDetailUpdate;

  final _databaseService = locator<DatabaseService>();

  List<Team> teams;

  Map<String, List<Player>> teamsPlayersMap;

  MatchesViewModel(this.isNewMatch, this.match, this.onMatchDetailUpdate){
    teams = [];
    teamsPlayersMap = Map();
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    teams = await _databaseService.getTeamsWithoutOtherRequestedTeams();
    teams.add(_databaseService.selectedTeam);

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  List<Team> suggestTeamsByPattern(String pattern) {
    if(pattern == null || pattern.isEmpty)
      return teams;
    return teams.where((team) => team.name.startsWith(pattern));
  }

  Future<void> loadTeamPlayers(String teamId) async {
    String categoryId = _databaseService.selectedCategory.id;
    List<Player> teamPlayers = await _databaseService.getPlayersByTeamAndCategory(teamId, categoryId);
    if(!teamsPlayersMap.containsKey(teamId))
      teamsPlayersMap.putIfAbsent(teamId, () => teamPlayers);
    else
      teamsPlayersMap.update(teamId, (_) => teamPlayers);
  }

  List<Player> suggestPlayersByPattern(String namePattern, String surnamePattern, String teamId) {
    List<Player> teamPlayers = teamsPlayersMap[teamId];
    if(teamPlayers == null)
      return [];
    if(namePattern.isEmpty) {
      return teamPlayers.where((player) => player.surname.startsWith(surnamePattern)).toList();
    }
    if(surnamePattern.isEmpty) {
      return teamPlayers.where((player) => player.name.startsWith(namePattern)).toList();
    }
    return teamPlayers.where((player) {
      return player.name.startsWith(namePattern) && player.surname.startsWith(surnamePattern);
    }).toList();
  }

  Future<void> onBottomBarItemChanged(BuildContext context, int index, bool isEditEnabled) async {
    await NavUtils.leaveBottomBarTab(context, index, isEditEnabled,
        TabScaffoldWidget.MATCHES_VIEW_INDEX, TabScaffoldWidget.ROSTER_VIEW_INDEX);
  }

  Future<void> onMatchSave(BuildContext context, Match newMatch) async {
    await _databaseService.saveMatch(newMatch);

    onMatchDetailUpdate(newMatch);

    // return to TeamView
    //Navigator.of(context).pop();

    match = Match.clone(newMatch);
  }

  Future<void> viewPlayerCard(BuildContext context, String playerId) async {
    Preconditions.requireArgumentNotNull(playerId);

    Player player = await _databaseService.getPlayerById(playerId);
    player = await _databaseService.completePlayerWithMissingInfo(player);
    bool playerExists = player != null;
    if(playerExists) {
      bool isNewPlayer = false;
      NavUtils.navToRosterView(context, RosterViewArguments(isNewPlayer, player, null));
    }
  }

  String getAppBarTitle() {
    return isNewMatch ? "Nuova Partita" : _databaseService.selectedTeam.name;
  }

}