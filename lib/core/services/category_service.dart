import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
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
      : super(databaseReference, CategoryRepository(databaseReference, locator<AppStateService>().selectedAppUser.id));

  Future<void> saveFollowedTeamCategory(Category category, String menuId, String seasonTeamId) async {
    await _saveCategoryToMenu(category, menuId);

    // Add category to the seasonTeam
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    await seasonTeamService.addCategoryToSeasonTeam(seasonTeamId, category.id);
  }

  Future<void> saveFollowedPlayersCategory(Category category, String menuId) async {
    await _saveCategoryToMenu(category, menuId);
  }

  Future<void> _saveCategoryToMenu(Category category, String menuId) async {
    // Save category
    await saveItem(category);
    // Add category to the menu
    MenuService menuService = MenuService(databaseReference);
    await menuService.addCategoryToMenu(category, menuId);
  }

  /// Get the team's categories
  Future<List<Category>> getTeamCategories(String seasonTeamId) async {
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    bool seasonTeamExists = await seasonTeamService.itemExists(seasonTeamId);
    if(!seasonTeamExists) {
      return [];
    }
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonTeamId);
    if(seasonTeam.categoriesIds.isEmpty)
      return [];
    return await getItemsByIds(seasonTeam.categoriesIds);
  }

  /// Get the current images used in the menu's categories
  Future<List<String>> getUsedCategoryImages(List<String> menuCategoriesIds) async {
    List<Category> categories = await getItemsByIds(menuCategoriesIds);
    return categories.map((e) => e.imageFilename).toList();
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
    Menu? menu = await menuService.findMenuWithCategory(categoryId);
    if(menu != null) {
      await menuService.removeCategoryFromMenu(categoryId, menu.id);
    }

    // Delete category
    await super.deleteItem(categoryId);
  }

}