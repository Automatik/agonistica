import 'package:agonistica/core/arguments/PlayerMatchesViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:agonistica/views/player_matches/player_matches_view.dart';
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

  Future<void> onBottomBarItemChanged(BuildContext context, int index, bool isEditEnabled) async {
    await NavUtils.leaveBottomBarTab(context, index, isEditEnabled,
        TabScaffoldWidget.ROSTER_VIEW_INDEX, TabScaffoldWidget.MATCHES_VIEW_INDEX);
  }

  Future<void> onPlayerSave(BuildContext context, Player newPlayer) async {
    //TODO Implement a check if a player with already the same name and surname exists?
    print("savePlayer");
    await _databaseService.savePlayer(newPlayer);
    print("onUpdate");
    // save eventually playerMatchNotes?

    if(onPlayerDetailUpdate != null) {
      onPlayerDetailUpdate(newPlayer);
    }
    print("clone");
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