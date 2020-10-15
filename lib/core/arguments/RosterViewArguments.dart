import 'package:agonistica/core/models/Player.dart';

class RosterViewArguments {

  bool isNewPlayer;
  Player player;
  Function(Player) onPlayerDetailUpdate;

  RosterViewArguments(this.isNewPlayer, this.player, this.onPlayerDetailUpdate);

}