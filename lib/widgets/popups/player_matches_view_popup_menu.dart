import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/widgets/popups/item_tile_object.dart';
import 'package:agonistica/widgets/popups/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerMatchesViewPopupMenu extends PopupMenu {

  static const int VIEW_MATCH_CARD = 0;
  static const int VIEW_NOTES_CARD = 1;
  static const int DELETE_MATCH_CARD = 2;

  PlayerMatchesViewPopupMenu({required offset, required itemValues}) : super(offset: offset, itemValues: itemValues);

  @override
  ItemTileObject selectItemTileObject(BuildContext context, int value) {
    switch(value) {
      case VIEW_MATCH_CARD: return ItemTileObject("Scheda Partita", FontAwesomeIcons.futbol);
      case VIEW_NOTES_CARD: return ItemTileObject("Note Partita", Icons.assignment_rounded);
      case DELETE_MATCH_CARD: return ItemTileObject("Elimina Partita", PlatformIcons(context).delete);
      default: throw ArgumentException("Value not found");
    }
  }



}