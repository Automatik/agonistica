import 'package:agonistica/core/models/player.dart';

class RosterViewArguments {

  bool isNewPlayer;
  Player player;
  Function(Player) onPlayerDetailUpdate;

  RosterViewArguments(this.isNewPlayer, this.player, this.onPlayerDetailUpdate);

}