import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {

  final otherPlayersList = ['Prima Squadra', 'Juniores', 'Allievi', 'Giovanissimi'];

  final _baseScaffoldService = locator<BaseScaffoldService>();

  HomeViewModel(){
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

  void onMainButtonTap(BuildContext context) {
    _baseScaffoldService.teamSelected = mainButtonTitle;
    Navigator.pushNamed(
        context,
        CategoriesView.routeName,
    );
  }

  void onOtherPlayersTap(BuildContext context, int index) {
    _baseScaffoldService.teamSelected = otherPlayersList[index];
  }

}