// @dart=2.9

import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/widgets/popups/item_tile_object.dart';
import 'package:agonistica/widgets/popups/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class TeamViewPopupMenu extends PopupMenu {

  static const int VIEW_MATCH_CARD = 0;
  static const int VIEW_PLAYER_CARD = 1;
  static const int DELETE_MATCH_CARD = 2;
  static const int DELETE_PLAYER_CARD = 3;

  TeamViewPopupMenu({offset, itemValues}) : super(offset: offset, itemValues: itemValues);

  @override
  selectItemTileObject(BuildContext context, int value) {
    switch(value) {
      case VIEW_MATCH_CARD: return ItemTileObject("Scheda Partita", FontAwesomeIcons.futbol);
      case VIEW_PLAYER_CARD: return ItemTileObject("Scheda Giocatore", PlatformIcons(context).person);
      case DELETE_MATCH_CARD:
      case DELETE_PLAYER_CARD: return ItemTileObject("Elimina", PlatformIcons(context).delete);
      default: throw ArgumentException("Value not found");
    }
  }



}