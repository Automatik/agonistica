import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/widgets/popups/item_tile_object.dart';
import 'package:agonistica/widgets/popups/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class PlayerItemPopupMenu extends PopupMenu {

  static const int VIEW_PLAYER_CARD = 1;
  static const int DELETE_PLAYER = 2;
  static const int VIEW_NOTES_CARD = 3;

  PlayerItemPopupMenu({required offset, required itemValues})
      : super(offset: offset, itemValues: itemValues);

  @override
  ItemTileObject selectItemTileObject(BuildContext context, int value) {
    switch(value) {
      case VIEW_PLAYER_CARD: return ItemTileObject("Scheda Giocatore", PlatformIcons(context).person);
      case DELETE_PLAYER: return ItemTileObject("Elimina", PlatformIcons(context).delete);
      case VIEW_NOTES_CARD: return ItemTileObject("Inserisci note", Icons.assignment_rounded);
      default: throw ArgumentException("Value not found");
    }
  }



}