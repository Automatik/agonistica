import 'package:agonistica/core/guards/preconditions.dart';
import 'package:uuid/uuid.dart';

class PlayerMatchNotes {

  String id;
  String playerId;
  String matchId;

  String notes;

  PlayerMatchNotes(this.matchId, this.playerId) {
    var uuid = Uuid();
    id = uuid.v4();
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
    Preconditions.requireFieldNotNull("id", id);
    Preconditions.requireFieldNotNull("playerId", playerId);
    Preconditions.requireFieldNotNull("matchId", matchId);
    Preconditions.requireFieldNotNull("notes", notes);
  }

}