import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class TeamViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  static Logger _logger = getLogger('DatabaseService');

  List<Match> matches;

  TeamViewModel(){
    matches = [];

    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    if(_databaseService.selectedCategory == null)
      _logger.d("selectedCategory is null");
    else
      matches = await _databaseService.getCategoryMatches(_databaseService.selectedCategory);

    // ONLY FOR TESTING
    if(matches.isEmpty) {
      Match match = Match();
      match.team1Id = _databaseService.selectedTeam.id;
      match.team1Name = "Merate";
      match.team2Name = "Robbiate";
      match.team1Goals = 2;
      match.team2Goals = 1;
      match.leagueMatch = 1;
      match.matchDate = DateTime.utc(2020, 09, 28);
    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

}