import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/exceptions/not_implemented_yet_exception.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/repositories/menu_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuService extends CrudService<Menu> {

  MenuService(DatabaseReference databaseReference)
    : super(databaseReference, MenuRepository(databaseReference, locator<AppStateService>().selectedAppUser.id));

  Future<void> addCategoryToMenu(Category category, String menuId) async {
    Menu menu = await getItemById(menuId);
    menu.addCategory(category.id);
    await saveItem(menu);
  }

  Future<void> removeCategoryFromMenu(String categoryId, String menuId) async {
    Menu menu = await getItemById(menuId);
    menu.removeCategory(categoryId);
    await saveItem(menu);
  }

  Future<List<Menu>> getFollowedTeamsMenus() async {
    List<Menu> menus = await getAllItems();
    return menus.where((element) => element.type == Menu.TYPE_FOLLOWED_TEAMS).toList();
  }

  Future<List<Menu>> getFollowedPlayersMenus() async {
    List<Menu> menus = await getAllItems();
    return menus.where((element) => element.type == Menu.TYPE_FOLLOWED_PLAYERS).toList();
  }

  Future<Menu> findMenuWithTeam(String teamId) async {
    List<Menu> menus = await getAllItems();
    int index = menus.indexWhere((element) => element.type == Menu.TYPE_FOLLOWED_TEAMS && element.teamId == teamId);
    if(index != -1) {
      return menus[index];
    }
    return null;
  }

  Future<Menu> findMenuWithCategory(String categoryId) async {
    List<Menu> menus = await getAllItems();
    int index = menus.indexWhere((element) => element.categoriesIds.contains(categoryId));
    if(index != -1) {
      return menus[index];
    }
    return null;
  }

  /// Get the current images used in the user's menus
  Future<List<String>> getUsedMenuImages() async {
    List<Menu> menus = await getAllItems();
    return menus.map((e) => e.imageFilename).toList();
  }

  @override
  Future<void> deleteItem(String itemId) async {
    throw NotImplementedYetException("Still need to think of consequences");
    // await super.deleteItem(itemId);
  }

}
