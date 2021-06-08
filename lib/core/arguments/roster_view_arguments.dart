// @dart=2.9

import 'package:agonistica/core/models/season_player.dart';

class RosterViewArguments {

  bool isNewPlayer;
  SeasonPlayer seasonPlayer;
  Function(SeasonPlayer) onPlayerDetailUpdate;

  RosterViewArguments(this.isNewPlayer, this.seasonPlayer, this.onPlayerDetailUpdate);

}