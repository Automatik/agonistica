import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';

class AppStateService {

  Menu selectedMenu;
  Team selectedTeam;
  Category selectedCategory;
  SeasonTeam selectedSeasonTeam;
  Season selectedSeason;

  bool isTeamMenu() {
    return selectedMenu.type == Menu.TYPE_FOLLOWED_TEAMS;
  }

  bool isPlayersMenu() {
    return selectedMenu.type == Menu.TYPE_FOLLOWED_PLAYERS;
  }

}