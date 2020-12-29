import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/views/matches/player_item.dart';
import 'package:flutter/material.dart';

class PlayerItemsRow extends StatelessWidget {

  final Player homePlayer; //left
  final Player awayPlayer; //right

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
        children: [
          PlayerItem(
            isLeftOrientation: true,
            player: homePlayer,
          ),
          PlayerItem(
            isLeftOrientation: false,
            player: awayPlayer,
          )
        ],
      ),
    );
  }

}