import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:uuid/uuid.dart';

class Match {

  String id;

  String team1Id, team2Id;

  int team1Goals, team2Goals;

  int leagueMatch;
  DateTime matchDate;

  // Leave this as temporary
  String team1Name, team2Name;

//  List<String> playersIds;

  List<MatchPlayerData> playersData;

  Match() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Match.empty() {
    var uuid = Uuid();
    id = uuid.v4();
    team1Id = uuid.v4();
    team2Id = uuid.v4();
    team1Goals = 0;
    team2Goals = 0;
    leagueMatch = 0;
    matchDate = DateTime.now();
    team1Name = "Squadra 1";
    team2Name = "Squadra 2";

    //add playersIds

    //call matchPlayerData.empty for all players
  }

}