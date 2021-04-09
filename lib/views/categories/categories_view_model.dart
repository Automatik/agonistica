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

  List<Category> _followedCategories = [];

  CategoriesViewModel(){
//    _followedCategories = List.from(requestedCategories, growable: true);
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    _followedCategories = await _databaseService.getMainCategories();


    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  String getAppBarTitle() {
    return _baseScaffoldService.teamSelected;
  }

  int getFollowedCategoriesCount() {
    return _followedCategories.length;
  }

  String getFollowedCategory(int index) {
    if(index < 0 || index >= _followedCategories.length)
      return "";
    return _followedCategories[index].name;
  }

  void onFollowedCategoryTap(BuildContext context, int index) {
    _databaseService.selectedCategory = _followedCategories[index];
    Navigator.pushNamed(
      context,
      TeamView.routeName,
      arguments: TeamViewArguments(TabScaffoldWidget.MATCHES_VIEW_INDEX)
    );
  }

}