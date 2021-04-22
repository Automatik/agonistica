import 'package:agonistica/core/exceptions/not_implemented_yet_exception.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/repositories/menu_repository.dart';
import 'package:agonistica/core/services/category_service.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:firebase_database/firebase_database.dart';

class MenuService extends CrudService<Menu> {

  MenuService(DatabaseReference databaseReference)
    : super(databaseReference, MenuRepository(databaseReference));

  Future<void> addCategoryToMenu(Category category, Menu menu) async {

    // Save new category
    CategoryService categoryService = CategoryService(databaseReference);
    await categoryService.saveItem(category);

    menu.addCategory(category.id);
    await saveItem(menu);
  }

  Future<void> removeCategoryFromMenu(Category category, Menu menu) async {
    menu.removeCategory(category.id);
    await saveItem(menu);
  }

  Future<Menu> getMainMenu() async {
    List<Menu> menus = await getAllItems();
    int index = menus.indexWhere((element) => element.name == mainRequestedTeam);
    return menus[index];
  }

  Future<List<Menu>> getOtherMenus() async {
    List<Menu> menus = await getAllItems();
    menus.removeWhere((element) => element.name == mainRequestedTeam);
    return menus;
  }

  @override
  Future<void> deleteItem(String itemId) async {
    throw NotImplementedYetException("Still need to think of consequences");
    // await super.deleteItem(itemId);
  }

}
