import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/views/matches/player_item.dart';
import 'package:flutter/material.dart';

class PlayerItemsRow extends StatelessWidget {

  final MatchPlayerData homePlayer; //left
  final MatchPlayerData awayPlayer; //right
  final double lineSeparatorWidth;
  final bool isEditEnabled;
  final bool Function(String, int, bool) onPlayerValidation;
  final List<SeasonPlayer> Function(String, String, bool) onPlayerSuggestionCallback;
  final Function(MatchPlayerData, bool) onSaveCallback;
  final Function(MatchPlayerData) onViewPlayerCardCallback;
  final Function(MatchPlayerData, bool) onDeleteCallback;
  final Function(MatchPlayerData) onInsertNotesCallback;

  PlayerItemsRow({
    @required this.homePlayer,
    @required this.awayPlayer,
    this.lineSeparatorWidth = 0.5,
    @required this.isEditEnabled,
    @required this.onPlayerValidation,
    @required this.onPlayerSuggestionCallback,
    @required this.onSaveCallback,
    @required this.onViewPlayerCardCallback,
    @required this.onDeleteCallback,
    @required this.onInsertNotesCallback,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: blueAgonisticaColor, width: lineSeparatorWidth))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 1,
            child: PlayerItem(
              isLeftOrientation: true,
              isEditEnabled: isEditEnabled,
              matchPlayer: homePlayer,
              onPlayerValidation: (id, shirtNumber) => onPlayerValidation(id, shirtNumber, true),
              onPlayersSuggestionCallback: (namePattern, surnamePattern) {
                bool isHomePlayer = true;
                return onPlayerSuggestionCallback(namePattern, surnamePattern, isHomePlayer);
              },
              onSaveCallback: (matchPlayerData) {
                bool isHomePlayer = true;
                onSaveCallback(matchPlayerData, isHomePlayer);
              },
              onViewPlayerCardCallback: onViewPlayerCardCallback,
              onDeleteCallback: (matchPlayerData) {
                bool isHomePlayer = true;
                onDeleteCallback(matchPlayerData, isHomePlayer);
              },
              onInsertNotesCallback: onInsertNotesCallback,
            ),
          ),
          Expanded(
            flex: 1,
            child: PlayerItem(
              isLeftOrientation: false,
              isEditEnabled: isEditEnabled,
              matchPlayer: awayPlayer,
              onPlayerValidation: (id, shirtNumber) => onPlayerValidation(id, shirtNumber, false),
              onPlayersSuggestionCallback: (namePattern, surnamePattern) {
                bool isHomePlayer = false;
                return onPlayerSuggestionCallback(namePattern, surnamePattern, isHomePlayer);
              },
              onSaveCallback: (matchPlayerData) {
                bool isHomePlayer = false;
                onSaveCallback(matchPlayerData, isHomePlayer);
              },
              onViewPlayerCardCallback: onViewPlayerCardCallback,
              onDeleteCallback: (matchPlayerData) {
                bool isHomePlayer = false;
                onDeleteCallback(matchPlayerData, isHomePlayer);
              },
              onInsertNotesCallback: onInsertNotesCallback,
            ),
          )
        ],
      ),
    );
  }

}