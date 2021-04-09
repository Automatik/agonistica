import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class CategoryRepository {

  DatabaseReference _databaseReference;
  String _firebaseCategoriesChild;

  static Logger _logger = getLogger('CategoryRepository');

  CategoryRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebaseCategoriesChild = DatabaseService.firebaseCategoriesChild;
  }

  // SET

  Future<void> saveCategory(Category category) async {
    Preconditions.requireArgumentNotNull(category.id);

    await _databaseReference.child(_firebaseCategoriesChild).child(category.id).set(category.toJson());
  }

  // GET

  /// Download Category data given its id
  Future<Category> getCategoryById(String categoryId) async {
    Preconditions.requireArgumentNotNull(categoryId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebaseCategoriesChild).child(categoryId).once();
    Category category;
    if(snapshot.value != null) {
      category = Category.fromJson(snapshot.value);
    }
    return category;
  }

  /// Download categories identified by the given ids
  Future<List<Category>> getCategoriesByIds(List<String> categoriesIds) async {
    Preconditions.requireArgumentsNotNulls(categoriesIds);

    List<Category> categories = List();
    for(String catId in categoriesIds) {
      final snapshot = await _databaseReference.child(_firebaseCategoriesChild).child(catId).once();
      final catValue = snapshot.value;
      if(catValue != null)
        categories.add(Category.fromJson(catValue));
    }
    return categories;
  }

  /// Download all categories in firebase
  Future<List<Category>> getCategories() async {
    DatabaseReference categoriesDatabaseReference = _databaseReference.child(DatabaseService.firebaseCategoriesChild);
    final DataSnapshot snapshot = await categoriesDatabaseReference.once();
    List<Category> categories = [];
    Map<dynamic, dynamic> values = snapshot.value;
    if(values != null)
      values.forEach((key, value) => categories.add(Category.fromJson(value)));
    return categories;
  }

}