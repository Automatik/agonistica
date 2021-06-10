import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/utils/db_utils.dart';

class Team {

  static const String EMPTY_TEAM_NAME = "Squadra";

  String? id;

  String? name;

  List<String>? seasonTeamsIds;

  String? imageFilename;

  Team() {
    id = DbUtils.newUuid();
  }

  Team.name(String? name, String? imageFilename) {
    id = DbUtils.newUuid();
    this.name = name;
    this.imageFilename = imageFilename;
    seasonTeamsIds = List.empty();
  }

  Team.nameWithNoId(String name, String imageFilename) {
    id = null;
    this.name = name;
    this.imageFilename = imageFilename;
    seasonTeamsIds = List.empty();
  }

  void addSeasonTeam(String seasonTeamId) {
    seasonTeamsIds = DbUtils.addToListIfAbsent(seasonTeamsIds, seasonTeamId);
  }

  void removeSeasonTeam(String seasonTeamId) {
    seasonTeamsIds = DbUtils.removeFromList(seasonTeamsIds, seasonTeamId);
  }

  bool hasEmptyName() {
    return isEmptyName(name);
  }

  static bool isEmptyName(String? name) {
    return name == EMPTY_TEAM_NAME;
  }

  Map<String, dynamic> toJson() {
    checkRequiredFields();

    return {
      'id': id,
      'name': name,
      'imageFilename': imageFilename,
      'seasonTeamsIds': seasonTeamsIds,
    };
  }

  Team.fromJson(Map<dynamic, dynamic> json)
      : id = json['id'],
        name = json['name'],
        imageFilename = json['imageFilename'],
        seasonTeamsIds = json['seasonTeamsIds'] == null ? List.empty() : List<String>.from(json['seasonTeamsIds']);

  void checkRequiredFields() {
    Preconditions.requireFieldNotEmpty("id", id!);
    Preconditions.requireFieldNotEmpty("name", name!);
  }

}