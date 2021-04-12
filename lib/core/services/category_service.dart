import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/repositories/category_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:agonistica/core/services/season_team_service.dart';
import 'package:firebase_database/firebase_database.dart';

class CategoryService extends CrudService<Category> {

  CategoryService(DatabaseReference databaseReference)
      : super(databaseReference, CategoryRepository(databaseReference));


  /// Get the team's categories
  Future<List<Category>> getTeamCategories(String seasonTeamId) async {
    SeasonTeamService seasonTeamService = SeasonTeamService(databaseReference);
    SeasonTeam seasonTeam = await seasonTeamService.getItemById(seasonTeamId);
    if(seasonTeam == null || seasonTeam.categoriesIds == null || seasonTeam.categoriesIds.isEmpty)
      return [];
    return await getItemsByIds(seasonTeam.categoriesIds);
  }


}