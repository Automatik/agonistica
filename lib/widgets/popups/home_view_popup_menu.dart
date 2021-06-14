import 'package:agonistica/widgets/popups/item_tile_object.dart';
import 'package:agonistica/widgets/popups/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class HomeViewPopupMenu extends PopupMenu {
  
  static const int CREATE_FOLLOWED_TEAM_MENU = 0;
  static const int CREATE_FOLLOWED_PLAYERS_MENU = 1;
  
  HomeViewPopupMenu({required offset})
    : super(offset: offset, itemValues: [CREATE_FOLLOWED_TEAM_MENU, CREATE_FOLLOWED_PLAYERS_MENU]);

  @override
  ItemTileObject selectItemTileObject(BuildContext context, int value) {
    switch(value) {
      case CREATE_FOLLOWED_TEAM_MENU: return ItemTileObject("Segui nuova squadra", PlatformIcons(context).group);
      case CREATE_FOLLOWED_PLAYERS_MENU: return ItemTileObject("Segui nuova macro-categoria", Icons.category);
      default: throw ArgumentError("Value not found");
    }
  }
  
  
  
}