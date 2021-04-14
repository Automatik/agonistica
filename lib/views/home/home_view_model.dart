import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  static Logger _logger = getLogger('HomeViewModel');


  Menu _mainMenu;
  List<Menu> _otherMenus = [];

  final _baseScaffoldService = locator<BaseScaffoldService>();

  HomeViewModel(){
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    _mainMenu = await _databaseService.menuService.getMainMenu();
    _otherMenus = await _databaseService.menuService.getOtherMenus();

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getMainMenuName() {
    return _mainMenu == null ? "" : _mainMenu.name;
  }

  int getOtherMenusCount() {
    return _otherMenus.length;
  }

  String getOtherMenuName(int index) {
    if(index < getOtherMenusCount()) {
      return _otherMenus[index].name;
    }
    return "";
  }

  void onMainButtonTap(BuildContext context) {
    setAppBarTitle(_mainMenu.name);
    navigateToCategoriesView(context, _mainMenu.categoriesIds);
  }

  void onOtherPlayersTap(BuildContext context, int index) {
    Menu menu = _otherMenus[index];
    setAppBarTitle(menu.name);
    navigateToCategoriesView(context, menu.categoriesIds);
  }

  void setAppBarTitle(String name) {
    _baseScaffoldService.teamSelected = name;
  }

  Future<void> navigateToCategoriesView(BuildContext context, List<String> categoriesIds) async {
    await Navigator.pushNamed(
      context,
      CategoriesView.routeName,
      arguments: CategoriesViewArguments(categoriesIds),
    );
  }

}