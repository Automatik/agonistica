import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/views/matches/matches_view.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CategoriesViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();

  List<String> _followedCategories;

  CategoriesViewModel(){
    _followedCategories = List.from(['Juniores Regionali A', 'Allievi Regionali A', 'Giovanissimi Regionali A']);
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

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
    return _followedCategories[index];
  }

  void onFollowedCategoryTap(BuildContext context, int index) {
    Navigator.pushNamed(
      context,
      TeamView.routeName,
//      MatchesView.routeName,
    );
  }

}