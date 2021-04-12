import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryRepository extends CrudRepository<Category>{

  CategoryRepository(DatabaseReference databaseReference)
      : super(databaseReference, DatabaseService.firebaseCategoriesChild);

  @override
  Map<String, dynamic> itemToJson(Category t) {
    return t.toJson();
  }

  @override
  Category jsonToItem(Map<dynamic, dynamic> json) {
    return Category.fromJson(json);
  }

  @override
  String getItemId(Category item) {
    return item.id;
  }

}