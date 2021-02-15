import 'package:agonistica/core/arguments/TeamViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/core/shared/tab_scaffold_widget.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MatchesViewModel extends BaseViewModel {

  final bool isNewMatch;
  Match match;
  final Function(Match) onMatchDetailUpdate;

  final _baseScaffoldService = locator<BaseScaffoldService>();
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

  void onBottomBarItemChanged(BuildContext context, int index) {
    // TODO Ask to save before leaving

    if(index == TabScaffoldWidget.MATCHES_VIEW_INDEX) {
      // This is possible only if we come to this MatchesView only from TeamView
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamed(
          TeamView.routeName,
          arguments: TeamViewArguments(TabScaffoldWidget.ROSTER_VIEW_INDEX)
      );
    }
  }

  Future<void> onMatchSave(BuildContext context, Match newMatch) async {
    await _databaseService.saveMatch(newMatch);

    onMatchDetailUpdate(newMatch);

    // return to TeamView
    //Navigator.of(context).pop();

    match = Match.clone(newMatch);
  }

  String getAppBarTitle() {
    return isNewMatch ? "Nuova Partita" : _databaseService.selectedTeam.name;
  }

}