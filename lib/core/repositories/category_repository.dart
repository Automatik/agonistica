import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryRepository extends CrudRepository<Category>{

  CategoryRepository(DatabaseReference databaseReference, String? firebaseUserId)
      : super(databaseReference, DatabaseService.firebaseCategoriesChild, firebaseUserId: firebaseUserId);

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