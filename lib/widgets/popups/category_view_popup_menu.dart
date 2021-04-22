import 'package:agonistica/core/exceptions/argument_exception.dart';
import 'package:agonistica/widgets/popups/item_tile_object.dart';
import 'package:agonistica/widgets/popups/popup_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CategoryViewPopupMenu extends PopupMenu {

  static const int DELETE_CATEGORY = 0;

  CategoryViewPopupMenu({offset})
      : super(offset: offset, itemValues: [DELETE_CATEGORY]);

  @override
  ItemTileObject selectItemTileObject(BuildContext context, int value) {
    switch(value) {
      case DELETE_CATEGORY: return ItemTileObject("Elimina", PlatformIcons(context).delete);
      default: throw ArgumentException("Value not found");
    }
  }



}