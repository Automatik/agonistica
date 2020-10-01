import 'package:uuid/uuid.dart';

class PlayerMatchNotes {

  String id;
  String playerId;
  String matchId;

  String notes;

  PlayerMatchNotes() {
    var uuid = Uuid();
    id = uuid.v4();
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'playerId': playerId,
    'matchId': matchId,
    'notes': notes
  };

  PlayerMatchNotes.fromJson(Map<dynamic, dynamic> json) :
      id = json['id'],
      playerId = json['playerId'],
      matchId = json['matchId'],
      notes = json['notes'];

}