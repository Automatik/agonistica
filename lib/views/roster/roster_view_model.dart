import 'package:agonistica/core/arguments/PlayerMatchesViewArguments.dart';
import 'package:agonistica/core/arguments/TeamViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/core/shared/tab_scaffold_widget.dart';
import 'package:agonistica/views/player_matches/player_matches_view.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RosterViewModel extends BaseViewModel {

  final bool isNewPlayer;
  Player player;
  final Function(Player) onPlayerDetailUpdate;
  final _databaseService = locator<DatabaseService>();

  List<Team> teams;

  RosterViewModel(this.isNewPlayer, this.player, this.onPlayerDetailUpdate){
    teams = [];
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    teams = await _databaseService.getTeamsWithoutOtherRequestedTeams();
    if(player != null) {
      Team playerTeam = await _databaseService.getTeamById(player.teamId);
      teams.add(playerTeam);
    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  List<Team> onSuggestionTeamCallback(String pattern) {
    if(pattern == null || pattern.isEmpty)
      return teams;

    return teams.where((team) => team.name.startsWith(pattern));
  }

  Future<List<Category>> getTeamCategories(Team team) async {
    return await _databaseService.getTeamCategories(team.id);
  }

  void onBottomBarItemChanged(BuildContext context, int index) {
    // TODO Ask to save before leaving

    if(index == TabScaffoldWidget.ROSTER_VIEW_INDEX) {
      // This is possible only if we come to this RosterView only from TeamView
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamed(
        TeamView.routeName,
        arguments: TeamViewArguments(TabScaffoldWidget.MATCHES_VIEW_INDEX)
      );
    }
  }

  Future<void> onPlayerSave(BuildContext context, Player newPlayer) async {
    await _databaseService.savePlayer(newPlayer);

    // save eventually playerMatchNotes?

    onPlayerDetailUpdate(newPlayer);

    // return to TeamView
//    Navigator.of(context).pop();

    player = Player.clone(newPlayer);
  }

  Future<void> navigateToPlayerMatchesNotes(BuildContext context) async {
    Navigator.of(context).pushNamed(
      PlayerMatchesView.routeName,
      arguments: PlayerMatchesViewArguments(player.id, "${player.name} ${player.surname}"),
    );
  }

  String getAppBarTitle() {
    return isNewPlayer ? "Nuovo Giocatore" : "${player.name} ${player.surname}";
  }

}