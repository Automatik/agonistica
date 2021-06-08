// @dart=2.9

import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class PlayerMatchNotes {

  String id;
  String seasonPlayerId;
  String matchId;

  String notes;

  PlayerMatchNotes(this.matchId, this.seasonPlayerId) {
    id = DbUtils.newUuid();
  }

  PlayerMatchNotes.clone(PlayerMatchNotes playerMatchNotes) {
    id = playerMatchNotes.id;
    seasonPlayerId = playerMatchNotes.seasonPlayerId;
    matchId = playerMatchNotes.matchId;
    notes = playerMatchNotes.notes;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'seasonPlayerId': seasonPlayerId,
      'matchId': matchId,
      'notes': notes
    };
  }

  PlayerMatchNotes.fromJson(Map<dynamic, dynamic> json) :
      id = json['id'],
      seasonPlayerId = json['seasonPlayerId'],
      matchId = json['matchId'],
      notes = json['notes'];

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
    Preconditions.requireFieldNotEmpty("seasonPlayerId", seasonPlayerId);
    Preconditions.requireFieldNotEmpty("matchId", matchId);
    Preconditions.requireFieldNotNull("notes", notes);
  }

}