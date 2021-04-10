import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

class SeasonRepository {

  DatabaseReference _databaseReference;
  String _firebaseSeasonsChild;

  static Logger _logger = getLogger('SeasonRepository');

  SeasonRepository(DatabaseReference databaseReference) {
    this._databaseReference = databaseReference;
    _firebaseSeasonsChild = DatabaseService.firebaseSeasonsChild;
  }

  // SET

  Future<void> saveSeason(Season season) async {
    Preconditions.requireArgumentNotEmpty(season.id);

    await _databaseReference.child(_firebaseSeasonsChild).child(season.id).set(season.toJson());
  }

  // GET

  Future<Season> getSeasonById(String seasonId) async {
    Preconditions.requireArgumentNotEmpty(seasonId);

    final DataSnapshot snapshot = await _databaseReference.child(_firebaseSeasonsChild).child(seasonId).once();
    Season season;
    if(snapshot.value != null) {
      season = Season.fromJson(snapshot.value);
    }
    return season;
  }

  Future<List<Season>> getSeasonsByIds(List<String> seasonsIds) async {
    Preconditions.requireArgumentsNotNulls(seasonsIds);

    List<Season> seasons = List();
    for(String seasonId in seasonsIds) {
      final snapshot = await _databaseReference.child(_firebaseSeasonsChild).child(seasonId).once();
      if(snapshot.value != null)
        seasons.add(Season.fromJson(snapshot.value));
    }
    return seasons;
  }

}