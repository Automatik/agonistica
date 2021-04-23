import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/category_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/match_service.dart';
import 'package:agonistica/core/services/menu_service.dart';
import 'package:agonistica/core/services/player_service.dart';
import 'package:agonistica/core/services/season_team_service.dart';
import 'package:agonistica/core/services/team_service.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryService extends CrudService<Category> {

  CategoryService(DatabaseReference databaseReference)
      : super(databaseReference, CategoryRepository(databaseReference));


  /// Get the team's categories
  Future<List<Category>> getTeamCategories(String seasonTeamId) async {
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    bool seasonTeamExists = await seasonTeamService.itemExists(seasonTeamId);
    if(!seasonTeamExists) {
      return [];
    }
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonTeamId);
    if(seasonTeam.categoriesIds == null || seasonTeam.categoriesIds.isEmpty)
      return [];
    return await getItemsByIds(seasonTeam.categoriesIds);
  }

  @override
  Future<void> deleteItem(String categoryId) async {
    // Delete players in this category
    PlayerService playerService = PlayerService(databaseReference);
    await playerService.deletePlayersInCategory(categoryId);
    // Delete matches in this category
    MatchService matchService = MatchService(databaseReference);
    await matchService.deleteMatchesInCategory(categoryId);
    // Delete teams in this category
    TeamService teamService = TeamService(databaseReference);
    await teamService.deleteTeamsInCategory(categoryId);
    // Delete category from menu
    MenuService menuService = MenuService(databaseReference);
    Menu menu = await menuService.findMenuWithCategory(categoryId);
    if(menu != null) {
      await menuService.removeCategoryFromMenu(categoryId, menu);
    }

    // Delete category
    await super.deleteItem(categoryId);
  }

}