import 'package:agonistica/core/arguments/MatchesViewArguments.dart';
import 'package:agonistica/core/arguments/RosterViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/views/matches/matches_view.dart';
import 'package:agonistica/views/roster/roster_view.dart';
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
      matches = await _databaseService.getTeamMatchesByCategory(
          _databaseService.selectedTeam, _databaseService.selectedCategory);
      matches = await _databaseService.completeMatchesWithMissingInfo(matches);

      players = await _databaseService.getPlayersByTeamAndCategory(_databaseService.selectedTeam.id,
          _databaseService.selectedCategory.id);


    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getWidgetTitle() {
    return _databaseService.selectedCategory.name;
  }

  Future<void> openMatchDetail(BuildContext context, int index) async {
    if(matches != null && matches.isNotEmpty) {
      Match match = matches[index];
      bool isNewMatch = false;
      Navigator.pushNamed(
        context,
        MatchesView.routeName,
        arguments: MatchesViewArguments(isNewMatch, match)
      );
    }
  }

  Future<void> openPlayerDetail(BuildContext context, int index) async {
    if(players != null && players.isNotEmpty) {
      Player player = players[index];
      bool isNewPlayer = false;
      Navigator.pushNamed(
        context,
        RosterView.routeName,
        arguments: RosterViewArguments(isNewPlayer, player)
      );
    }
  }

  Future<void> addNewMatch(BuildContext context) async {
    bool isNewMatch = true;
    Match match = Match.empty();
    match.categoryId = _databaseService.selectedCategory.id;
    Navigator.pushNamed(
      context,
      MatchesView.routeName,
      arguments: MatchesViewArguments(isNewMatch, match)
    );
  }

  Future<void> addNewPlayer(BuildContext context) async {
    bool isNewPlayer = true;
    Player player = Player.empty();
    player.setCategory(_databaseService.selectedCategory);
    player.setTeam(_databaseService.selectedTeam);
    Navigator.pushNamed(
      context,
      RosterView.routeName,
      arguments: RosterViewArguments(isNewPlayer, player)
    );
  }

}