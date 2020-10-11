import 'package:agonistica/core/models/Player.dart';
import 'package:flutter/material.dart';

class PlayerDetailLayout extends StatefulWidget {

  final bool isNewPlayer;
  final Player player;
  final double maxWidth;

  PlayerDetailLayout({
    @required this.isNewPlayer,
    @required this.player,
    this.maxWidth
  }) : assert(player != null);

  @override
  State<StatefulWidget> createState() => _PlayerDetailLayoutState();

}

class _PlayerDetailLayoutState extends State<PlayerDetailLayout> {

  bool editEnabled;

  Player tempPlayer;

  @override
  void initState() {
    super.initState();
    // if it's a new player enable already edit mode, otherwise start in view mode
    editEnabled = widget.isNewPlayer;


  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

}