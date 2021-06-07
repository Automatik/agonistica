import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/views/matches/player_item.dart';
import 'package:flutter/material.dart';

class PlayerReorderableList extends StatelessWidget {

  final bool isEditEnabled;
  final bool isLeftOrientation;
  final List<MatchPlayerData> players;
  final Function(int, int) onReorder;
  final bool Function(String, int) onPlayerValidation;
  final List<SeasonPlayer> Function(String, String) onPlayerSuggestionCallback;
  final Function(MatchPlayerData) onSaveCallback;
  final Function(MatchPlayerData) onViewPlayerCardCallback;
  final Function(MatchPlayerData) onDeleteCallback;
  final Function(MatchPlayerData) onInsertNotesCallback;

  PlayerReorderableList({
    @required this.isEditEnabled,
    @required this.isLeftOrientation,
    @required this.players,
    @required this.onReorder,
    @required this.onPlayerValidation,
    @required this.onPlayerSuggestionCallback,
    @required this.onSaveCallback,
    @required this.onViewPlayerCardCallback,
    @required this.onDeleteCallback,
    @required this.onInsertNotesCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      children: playerList(),
      onReorder: onReorder,
      scrollDirection: Axis.vertical,
    );
  }

  List<Widget> playerList() {
    List<Widget> list = [];
    for(int i = 0; i < players.length; i++) {
      Widget item = playerItem(players[i], i);
      list.add(item);
    }
    return list;
  }

  Widget playerItem(MatchPlayerData player, int index) {
    return PlayerItem(
      key: Key('$index'),
      matchPlayer: player,
      isLeftOrientation: isLeftOrientation,
      isEditEnabled: isEditEnabled,
      onPlayerValidation: (id, shirtNumber) => onPlayerValidation(id, shirtNumber),
      onPlayersSuggestionCallback: onPlayerSuggestionCallback,
      onSaveCallback: onSaveCallback,
      onViewPlayerCardCallback: onViewPlayerCardCallback,
      onDeleteCallback: onDeleteCallback,
      onInsertNotesCallback: onInsertNotesCallback
    );
  }


}