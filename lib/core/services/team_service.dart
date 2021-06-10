

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/exceptions/integrity_exception.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/repositories/team_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/followed_teams_service.dart';
import 'package:agonistica/core/services/menu_service.dart';
import 'package:agonistica/core/services/season_team_service.dart';
import 'package:firebase_database/firebase_database.dart';

class TeamService extends CrudService<Team> {

  TeamService(DatabaseReference databaseReference)
    : super(databaseReference, TeamRepository(databaseReference, locator<AppStateService>().selectedAppUser!.id));

  // SET

  Future<void> createTeamFromSeasonTeam(SeasonTeam seasonTeam) async {
    bool teamExists = await itemExists(seasonTeam.teamId!);
    if(!teamExists) {
      if(seasonTeam.team == null) {
        throw NotFoundException("Team with id ${seasonTeam.teamId} does not "
            "exist and team attribute of SeasonTeam object is null. Can't "
            "create a Team with no name");
      }
      if(seasonTeam.team!.id != seasonTeam.teamId) {
        throw IntegrityException("seasonTeam.team.id must be equal to seasonTeam.teamId");
      }
      Team team = seasonTeam.team!;
      team.addSeasonTeam(seasonTeam.id);
      await super.saveItem(team);
    }
  }

  Future<void> addSeasonTeamToTeam(String seasonTeamId, Team team) async {
    team.addSeasonTeam(seasonTeamId);
    await super.saveItem(team);
  }

  // GET

  /// Download Team data given its name and searching only across the team whose id is given
  Future<Team?> getTeamByNameFromIds(String teamName, List<String> teamsIds) async {
    bool teamFound = false;
    Team? team;
    int i = 0;
    while(i < teamsIds.length && !teamFound) {
      team = await getItemById(teamsIds[i]);
      if(team.name == teamName) {
        teamFound = true;
      }
      i++;
    }
    return team;
  }

  Future<List<String>> getUsedTeamImages() async {
    List<Team> teams = await getAllItems();
    return teams.map((e) => e.imageFilename).toList() as List<String>;
  }

  // DELETE

  @override
  Future<void> deleteItem(String teamId) async {
    Team team = await getItemById(teamId);

    // Delete season teams for this team
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    for(String seasonTeamId in team.seasonTeamsIds as Iterable<String>) {
      await seasonTeamService.deleteItem(seasonTeamId);
    }

    // Unfollow team (get user' followedTeams and then call followedTeams.unFollow)
    FollowedTeamsService followedTeamsService = FollowedTeamsService(databaseReference);
    bool isTeamFollowed = await followedTeamsService.isTeamFollowed(teamId);
    if(isTeamFollowed) {
      await followedTeamsService.unFollowTeam(teamId);

      //If it's a followed team remove the relative menu
      MenuService menuService = MenuService(databaseReference);
      Menu? menu = await menuService.findMenuWithTeam(teamId);
      bool menuExists = menu != null;
      if(menuExists) {
        await menuService.deleteItem(menu.id!);
      }
    }


    return super.deleteItem(teamId);
  }

  Future<void> deleteTeamsInCategory(String categoryId) async {
    List<Team> teams = await getAllItems();
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    teams.forEach((t) async {
      List<SeasonTeam> seasonTeams = await seasonTeamService.getItemsByIds(t.seasonTeamsIds as List<String>);
      await seasonTeamService.deleteSeasonTeamsInCategory(seasonTeams, categoryId);
      // TODO Delete team if there are no more seasonTeams?
      // if(seasonTeams.length <= 1) {
      //   await deleteItem(t.id);
      // }
    });
  }

  Future<void> deleteSeasonTeamFromTeam(String seasonTeamId, Team team) async {
    team.removeSeasonTeam(seasonTeamId);
    await super.saveItem(team);
  }

}