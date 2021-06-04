import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/assets/menu_assets.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:agonistica/core/utils/my_strings.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  static Logger _logger = getLogger('HomeViewModel');

  HomeMenus _homeMenus;

  HomeViewModel(){
    _homeMenus = HomeMenus();
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    _homeMenus = await _databaseService.getHomeMenus();

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getAppBarTitle() {
    return MyStrings.HOME_VIEW_APP_BAR_TITLE;
  }

  int getFollowedTeamsMenusSize() {
    return _homeMenus.getFollowedTeamsMenus().size();
  }

  int getFollowedPlayersMenusSize() {
    return _homeMenus.getFollowedPlayersMenus().size();
  }

  Menu getFollowedTeamMenu(int index) {
    return _homeMenus.getFollowedTeamsMenus().elementAt(index);
  }

  Menu getFollowedPlayerMenu(int index) {
    return _homeMenus.getFollowedPlayersMenus().elementAt(index);
  }

  Future<void> onFollowedTeamMenuTap(BuildContext context, int index) async {
    Menu menu = getFollowedTeamMenu(index);
    _appStateService.selectFollowedTeamMenu(context, menu);
  }

  Future<void> onFollowedPlayerMenuTap(BuildContext context, int index) async {
    Menu menu = getFollowedPlayerMenu(index);
    _appStateService.selectFollowedPlayersMenu(context, menu);
  }

  /// Check if no other menu exist with this name and the menu name is valid
  String validateNewMenu(String menuName) {
    String validationResult = InputValidation.validateMenuName(menuName);
    if(validationResult != null) {
      // not valid
      return validationResult;
    }
    List<String> menuNames = _getAllMenuNames();
    bool menuAlreadyExists = menuNames.contains(menuName);
    if(menuAlreadyExists) {
      return "Nome già presente";
    }
    return null; //Everything ok
  }

  Future<void> createNewMenu(String menuName, int menuType) async {
    Menu menu = await _databaseService.createNewMenu(menuName, menuType);
    if(menu == null) {
      return;
    }
    if(menuType == Menu.TYPE_FOLLOWED_TEAMS) {
      _homeMenus.addFollowedTeamMenu(menu);
    } else {
      _homeMenus.addFollowedPlayersMenu(menu);
    }
    // update view
    notifyListeners();
  }

  List<String> _getAllMenuNames() {
    List<String> list1 = _homeMenus.getFollowedTeamsMenusList().map((e) => e.name).toList();
    List<String> list2 = _homeMenus.getFollowedPlayersMenusList().map((e) => e.name).toList();
    list1.addAll(list2);
    return list1;
  }

}