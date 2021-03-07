import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/views/matches/player_item.dart';
import 'package:flutter/material.dart';

class PlayerItemsRow extends StatelessWidget {

  final MatchPlayerData homePlayer; //left
  final MatchPlayerData awayPlayer; //right
  final double lineSeparatorWidth;
  final bool isEditEnabled;
  final bool Function(String, int, bool) onPlayerValidation;
  final List<Player> Function(String, String, bool) onPlayerSuggestionCallback;
  final void Function(MatchPlayerData, bool) onSaveCallback;

  PlayerItemsRow({
    @required this.homePlayer,
    @required this.awayPlayer,
    this.lineSeparatorWidth = 0.5,
    @required this.isEditEnabled,
    @required this.onPlayerValidation,
    @required this.onPlayerSuggestionCallback,
    @required this.onSaveCallback,
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
              onPlayerValidation: (playerId, shirtNumber) => onPlayerValidation(playerId, shirtNumber, true),
              onPlayersSuggestionCallback: (namePattern, surnamePattern) {
                bool isHomePlayer = true;
                return onPlayerSuggestionCallback(namePattern, surnamePattern, isHomePlayer);
              },
              onSaveCallback: (matchPlayerData) {
                bool isHomePlayer = true;
                onSaveCallback(matchPlayerData, isHomePlayer);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: PlayerItem(
              isLeftOrientation: false,
              isEditEnabled: isEditEnabled,
              matchPlayer: awayPlayer,
              onPlayerValidation: (playerId, shirtNumber) => onPlayerValidation(playerId, shirtNumber, false),
              onPlayersSuggestionCallback: (namePattern, surnamePattern) {
                bool isHomePlayer = false;
                return onPlayerSuggestionCallback(namePattern, surnamePattern, isHomePlayer);
              },
              onSaveCallback: (matchPlayerData) {
                bool isHomePlayer = false;
                onSaveCallback(matchPlayerData, isHomePlayer);
              },
            ),
          )
        ],
      ),
    );
  }

}