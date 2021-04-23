import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class PlayersViewModel extends BaseViewModel {

  static Logger _logger = getLogger('PlayersViewModel');

  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  PlayersViewModel() {
    loadItems();
  }

  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

}