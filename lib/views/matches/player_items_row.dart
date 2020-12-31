import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/views/matches/player_item.dart';
import 'package:flutter/material.dart';

class PlayerItemsRow extends StatelessWidget {

  final MatchPlayerData homePlayer; //left
  final MatchPlayerData awayPlayer; //right
  final double lineSeparatorWidth;

  PlayerItemsRow({
    this.homePlayer,
    this.awayPlayer,
    this.lineSeparatorWidth = 0.5,
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
            child: PlayerItem(
              isLeftOrientation: true,
              matchPlayer: homePlayer,
            ),
          ),
          Expanded(
            child: PlayerItem(
              isLeftOrientation: false,
              matchPlayer: awayPlayer,
            ),
          )
        ],
      ),
    );
  }

}