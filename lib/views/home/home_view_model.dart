import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  static Logger _logger = getLogger('HomeViewModel');

  //final otherPlayersList = ['Prima Squadra', 'Juniores', 'Allievi', 'Giovanissimi'];
  //final otherPlayersList = List.from(requestedTeams, growable: true);
  List<Team> otherPlayersList = [];

  final _baseScaffoldService = locator<BaseScaffoldService>();

  HomeViewModel(){
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    List<Team> mainTeams = await _databaseService.getMainTeams();
//    otherPlayersList = mainTeams.where((element) => element.name != mainRequestedTeam);
    Iterable<Team> iterable = mainTeams.where((element) => element.name != mainRequestedTeam);
    otherPlayersList = List.from(iterable);

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  void onMainButtonTap(BuildContext context) {
    _baseScaffoldService.teamSelected = mainRequestedTeam;
    if(_databaseService.mainTeams == null || _databaseService.mainTeams.isEmpty)
      _logger.d("mainTeams in databaseService is null or empty");
    int index = _databaseService.mainTeams.indexWhere((team) => team.name == mainRequestedTeam);
    if(index > -1)
      _databaseService.selectedTeam = _databaseService.mainTeams[index];
    Navigator.pushNamed(
        context,
        CategoriesView.routeName,
    );
  }

  void onOtherPlayersTap(BuildContext context, int index) {
    _baseScaffoldService.teamSelected = otherPlayersList[index].name;
    _databaseService.selectedTeam = otherPlayersList[index];
  }

}