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

  Map<String, dynamic> toJson() => {
    'id': id,
    'team1Id': team1Id,
    'team2Id': team2Id,
    'team1Goals': team1Goals,
    'team2Goals': team2Goals,
    'leagueMatch': leagueMatch,
    'matchDate': matchDate,
    'team1Name': team1Name,
    'team2Name': team2Name,
    'playersData': playersData == null ? List() : List.generate(playersData.length, (index) => playersData[index].toJson())
  };

  Match.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      team1Id = json['team1Id'],
      team2Id = json['team2Id'],
      team1Goals = json['team1Goals'],
      team2Goals = json['team2Goals'],
      leagueMatch = json['leagueMatch'],
      matchDate = json['matchDate'],
      team1Name = json['team1Name'],
      team2Name = json['team2Name'],
      playersData = json['playersData'] == null ? List() : List.generate(json['playersData'].length, (index) => MatchPlayerData.fromJson(json['playersData'][index]));
}