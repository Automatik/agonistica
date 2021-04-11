import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryRepository extends CrudRepository<Category>{

  CategoryRepository(DatabaseReference databaseReference)
      : super(databaseReference, DatabaseService.firebaseCategoriesChild);

  // SET

  Future<void> saveCategory(Category category) async {
    await super.saveItem(category.id, category);
  }

  // GET

  /// Download Category data given its id
  Future<Category> getCategoryById(String categoryId) async {
    return await super.getItemById(categoryId);
  }

  /// Download categories identified by the given ids
  Future<List<Category>> getCategoriesByIds(List<String> categoriesIds) async {
    return await super.getItemsByIds(categoriesIds);
  }

  /// Download all categories in firebase
  Future<List<Category>> getCategories() async {
    return await super.getAllItems();
  }

  @override
  Map<String, dynamic> itemToJson(Category t) {
    return t.toJson();
  }

  @override
  Category jsonToItem(Map<dynamic, dynamic> json) {
    return Category.fromJson(json);
  }

}