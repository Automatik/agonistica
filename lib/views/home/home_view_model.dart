import 'package:stacked/stacked.dart';

class HomeViewModel extends BaseViewModel {

  final otherPlayersList = ['Prima Squadra', 'Juniores', 'Allievi', 'Giovanissimi'];

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

  void onOtherPlayersTap(int index) {

  }

}