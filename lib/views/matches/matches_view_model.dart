import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:stacked/stacked.dart';

class MatchesViewModel extends BaseViewModel {

  final _baseScaffoldService = locator<BaseScaffoldService>();

  MatchesViewModel(){
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

}