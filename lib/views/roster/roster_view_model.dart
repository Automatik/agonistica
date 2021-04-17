import 'package:agonistica/core/arguments/PlayerMatchesViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:agonistica/views/player_matches/player_matches_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class RosterViewModel extends BaseViewModel {

  final bool isNewPlayer;
  SeasonPlayer seasonPlayer;
  final Function(SeasonPlayer) onPlayerDetailUpdate;

  final _databaseService = locator<DatabaseService>();

  List<SeasonTeam> seasonTeams;

  RosterViewModel(this.isNewPlayer, this.seasonPlayer, this.onPlayerDetailUpdate){
    seasonTeams = [];
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    seasonTeams = await _databaseService.seasonTeamService.getSeasonTeamsWithSeason(seasonPlayer.seasonId);
    for(SeasonTeam seasonTeam in seasonTeams) {
      seasonTeam = await _databaseService.seasonTeamService.completeSeasonTeamWithMissingInfo(seasonTeam);
    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  List<SeasonTeam> onSuggestionTeamCallback(String pattern) {
    if(pattern == null || pattern.isEmpty)
      return seasonTeams;

    return seasonTeams.where((team) => team.getTeamName().startsWith(pattern));
  }

  Future<List<Category>> getTeamCategories(SeasonTeam seasonTeam) async {
    return await _databaseService.categoryService.getTeamCategories(seasonTeam.id);
  }

  Future<void> onBottomBarItemChanged(BuildContext context, int index, bool isEditEnabled) async {
    await NavUtils.leaveBottomBarTab(context, index, isEditEnabled,
        TabScaffoldWidget.ROSTER_VIEW_INDEX, TabScaffoldWidget.MATCHES_VIEW_INDEX);
  }

  Future<void> onPlayerSave(BuildContext context, SeasonPlayer newSeasonPlayer) async {
    //TODO Implement a check if a player with already the same name and surname exists?
    print("savePlayer");
    await _databaseService.seasonPlayerService.saveItem(newSeasonPlayer);
    print("onUpdate");
    // save eventually playerMatchNotes?

    if(onPlayerDetailUpdate != null) {
      onPlayerDetailUpdate(newSeasonPlayer);
    }
    print("clone");
    // return to TeamView
//    Navigator.of(context).pop();

    seasonPlayer = SeasonPlayer.clone(newSeasonPlayer);
  }

  Future<void> navigateToPlayerMatchesNotes(BuildContext context) async {
    Navigator.of(context).pushNamed(
      PlayerMatchesView.routeName,
      arguments: PlayerMatchesViewArguments(seasonPlayer.id, "${seasonPlayer.getPlayerName()} ${seasonPlayer.getPlayerSurname()}"),
    );
  }

  String getAppBarTitle() {
    return isNewPlayer ? "Nuovo Giocatore" : "${seasonPlayer.getPlayerName()} ${seasonPlayer.getPlayerSurname()}";
  }

}