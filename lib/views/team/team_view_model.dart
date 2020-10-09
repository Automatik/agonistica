import 'package:agonistica/core/arguments/MatchesViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/views/matches/matches_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class TeamViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  static Logger _logger = getLogger('TeamViewModel');

  List<Match> matches;

  TeamViewModel(){
    matches = [];

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

}