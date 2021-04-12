import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/repositories/player_repository.dart';
import 'package:agonistica/core/services/crud_service.dart';
import 'package:firebase_database/firebase_database.dart';

class PlayerService extends CrudService<Player> {

  PlayerService(DatabaseReference databaseReference)
    : super(databaseReference, PlayerRepository(databaseReference));

}