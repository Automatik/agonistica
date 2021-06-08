// @dart=2.9

import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class FollowedPlayers {

  String id;

  List<String> playersIds;

  FollowedPlayers() {
    id = DbUtils.newUuid();
  }

  FollowedPlayers.empty() {
    id = DbUtils.newUuid();
    playersIds = List();
  }

  void addPlayer(String playerId) {
    playersIds = DbUtils.addToListIfAbsent(playersIds, playerId);
  }

  void removePlayer(String playerId) {
    playersIds = DbUtils.removeFromList(playersIds, playerId);
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'teamsIds': playersIds
    };
  }

  FollowedPlayers.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        playersIds = json['playersIds'] == null ? List() : List<String>.from(json['playersIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id);
  }

}