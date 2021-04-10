import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class PlayerMatchNotes {

  String id;
  String playerId;
  String matchId;

  String notes;

  PlayerMatchNotes(this.matchId, this.playerId) {
    id = DbUtils.newUuid();
  }

  PlayerMatchNotes.clone(PlayerMatchNotes playerMatchNotes) {
    id = playerMatchNotes.id;
    playerId = playerMatchNotes.playerId;
    matchId = playerMatchNotes.matchId;
    notes = playerMatchNotes.notes;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'playerId': playerId,
      'matchId': matchId,
      'notes': notes
    };
  }

  PlayerMatchNotes.fromJson(Map<dynamic, dynamic> json) :
      id = json['id'],
      playerId = json['playerId'],
      matchId = json['matchId'],
      notes = json['notes'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("playerId", playerId);
    Preconditions.requireFieldNotEmpty("matchId", matchId);
    Preconditions.requireFieldNotNull("notes", notes);
  }

}