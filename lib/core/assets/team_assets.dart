import 'package:agonistica/core/utils/random_utils.dart';

class TeamAssets {

  static const String TEAM_IMAGE1 = "assets/teams/football_team1.svg";
  static const String TEAM_IMAGE2 = "assets/teams/football_team2.svg";
  static const String TEAM_IMAGE3 = "assets/teams/football_team3.svg";
  static const String TEAM_IMAGE4 = "assets/teams/football_team4.svg";
  static const String TEAM_IMAGE5 = "assets/teams/football_team5.svg";
  static const String TEAM_IMAGE6 = "assets/teams/football_team6.svg";
  static const String TEAM_IMAGE7 = "assets/teams/football_team7.svg";
  static const String TEAM_IMAGE8 = "assets/teams/football_team8.svg";
  static const String TEAM_IMAGE9 = "assets/teams/football_team9.svg";

  static List<String> getImagesArray() {
    return [
      TEAM_IMAGE1,
      TEAM_IMAGE2,
      TEAM_IMAGE3,
      TEAM_IMAGE4,
      TEAM_IMAGE5,
      TEAM_IMAGE6,
      TEAM_IMAGE7,
      TEAM_IMAGE8,
      TEAM_IMAGE9
    ];
  }

  static String getRandomImage() {
    List<String> images = getImagesArray();
    int number = RandomUtils.randomInt(images.length);
    return images[number];
  }

}