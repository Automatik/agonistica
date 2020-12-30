import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/views/matches/player_item.dart';
import 'package:flutter/material.dart';

class PlayerItemsRow extends StatelessWidget {

  final MatchPlayerData homePlayer; //left
  final MatchPlayerData awayPlayer; //right

  PlayerItemsRow({
    this.homePlayer,
    this.awayPlayer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
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