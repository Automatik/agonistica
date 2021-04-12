import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/repositories/crud_repository.dart';
import 'package:agonistica/core/services/database_service.dart';
import 'package:firebase_database/firebase_database.dart';

class SeasonPlayerRepository extends CrudRepository<SeasonPlayer> {

  SeasonPlayerRepository(DatabaseReference databaseReference)
    : super(databaseReference, DatabaseService.firebaseSeasonPlayersChild);

  @override
  Map<String, dynamic> itemToJson(SeasonPlayer t) {
    return t.toJson();
  }

  @override
  SeasonPlayer jsonToItem(Map<dynamic, dynamic> json) {
    return SeasonPlayer.fromJson(json);
  }

  @override
  String getItemId(SeasonPlayer item) {
    return item.id;
  }

}