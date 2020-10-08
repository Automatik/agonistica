import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class TeamViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  static Logger _logger = getLogger('TeamViewModel');

  List<Match> matches;

  TeamViewModel(){
    matches = [];

    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    if(_databaseService.selectedTeam == null || _databaseService.selectedCategory == null)
      _logger.d("selectedTeam or selectedCategory is null");
    else
      matches = await _databaseService.getTeamMatchesByCategory(_databaseService.selectedTeam, _databaseService.selectedCategory);

    // ONLY FOR TESTING
    if(matches.isEmpty) {
      Match match = Match.empty();
      match.categoryId = _databaseService.selectedCategory.id;
      match.team1Id = _databaseService.selectedTeam.id;
      match.team1Name = _databaseService.selectedTeam.name;
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