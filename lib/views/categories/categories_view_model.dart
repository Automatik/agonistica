import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/team_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/views/players/players_view.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoriesViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  List<Category> _menuCategories = [];

  CategoriesViewModel(List<String> menuCategoriesIds) {
    loadItems(menuCategoriesIds);
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems(List<String> menuCategoriesIds) async {
    setBusy(true);
    //Write your models loading codes here

    _menuCategories = await _databaseService.categoryService.getItemsByIds(menuCategoriesIds);


    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getAppBarTitle() {
    return _baseScaffoldService.teamSelected;
  }

  int getFollowedCategoriesCount() {
    return _menuCategories.length;
  }

  String getFollowedCategory(int index) {
    if(index < 0 || index >= _menuCategories.length)
      return "";
    return _menuCategories[index].name;
  }

  void onFollowedCategoryTap(BuildContext context, int index) {
    _appStateService.selectedCategory = _menuCategories[index];
    int menuType = _appStateService.selectedMenu.type;
    if(menuType == Menu.TYPE_FOLLOWED_TEAMS) {
      Navigator.pushNamed(
          context,
          TeamView.routeName,
          arguments: TeamViewArguments(TabScaffoldWidget.MATCHES_VIEW_INDEX)
      );
      return;
    }
    if(menuType == Menu.TYPE_FOLLOWED_PLAYERS) {
      Navigator.pushNamed(
          context,
          PlayersView.routeName,
      );
      return;
    }
  }

  Future<void> onFollowedCategoryLongTap(int index) async {
    Category category = _menuCategories[index];
    await _databaseService.categoryService.deleteItem(category.id);
    _appStateService.selectedMenu.categoriesIds.remove(category.id);
    // update view
    notifyListeners();
  }

  /// Check if no other category exist with this name (within that menu)
  Future<bool> validateNewCategory(String categoryName) async {
    List<String> categories = _menuCategories.map((e) => e.name);
    return categories.contains(categoryName);
  }

  Future<void> createNewCategory(String categoryName) async {
    Category category = Category.name(categoryName);
    await _databaseService.menuService.addCategoryToMenu(category, _appStateService.selectedMenu);
    _menuCategories.add(category);
    notifyListeners();
  }

}