import 'package:agonistica/core/arguments/TeamViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoriesViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();
  final _databaseService = locator<DatabaseService>();

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
    _databaseService.selectedCategory = _menuCategories[index];
    Navigator.pushNamed(
      context,
      TeamView.routeName,
      arguments: TeamViewArguments(TabScaffoldWidget.MATCHES_VIEW_INDEX)
    );
  }

}