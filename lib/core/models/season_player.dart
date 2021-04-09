import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class SeasonPlayer {

  String id;
  String playerId;
  String seasonTeamId;
  String seasonId;
  List<String> matchesIds;

  //TODO Valutare se includere come attributo anche playerMatchNotesIds e
  // quello temporaneo di playerMatchesNotes

  // temporary
  Player player;

  SeasonPlayer() {
    id = DbUtils.newUuid();
  }

  SeasonPlayer.empty(String playerId, String seasonTeamId, String seasonId) {
    Preconditions.requireArgumentNotNull(playerId);
    Preconditions.requireArgumentNotNull(seasonTeamId);
    Preconditions.requireArgumentNotNull(seasonId);

    id = DbUtils.newUuid();
    this.playerId = playerId;
    this.seasonTeamId = seasonTeamId;
    this.seasonId = seasonId;
    matchesIds = List();
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'playerId': playerId,
      'seasonTeamId': seasonTeamId,
      'seasonId': seasonId,
      'matchesIds': matchesIds
    };
  }

  SeasonPlayer.fromJson(Map<dynamic, dynamic> json)
    : id = json['id'],
      playerId = json['playerId'],
      seasonTeamId = json['seasonTeamId'],
      seasonId = json['seasonId'],
      matchesIds = json['matchesIds'] == null ? List() : List<String>.from(json['matchesIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotNull("id", id);
    Preconditions.requireFieldNotNull("playerId", playerId);
    Preconditions.requireFieldNotNull("seasonTeamId", seasonTeamId);
    Preconditions.requireFieldNotNull("seasonId", seasonId);
  }

}