import 'package:agonistica/widgets/popups/item_tile_object.dart';
import 'package:agonistica/widgets/popups/popup_menu_item_tile.dart';
import 'package:flutter/material.dart';

abstract class PopupMenu {

  final Offset offset;
  final List<int> itemValues;

  PopupMenu({
    required this.offset,
    required this.itemValues,
  });

  Future<int?> showPopupMenu(BuildContext context) async {
    double left = offset.dx;
    double top = offset.dy;
    int? value = await showMenu(
        context: context,
        position: RelativeRect.fromLTRB(left, top, left+1, top+1),
        items: createPopupMenuItems(context, itemValues),
    );
    return value;
  }

  List<PopupMenuItem<int>> createPopupMenuItems(BuildContext context, List<int> values) {
    return values.map((itemValue) {
      ItemTileObject itemTileObject = selectItemTileObject(context, itemValue);
      return PopupMenuItem(
        value: itemValue,
        child: PopupMenuItemTile(
          text: itemTileObject.text,
          iconData: itemTileObject.icon,
      )
      );
    }).toList();
  }

  ItemTileObject selectItemTileObject(BuildContext context, int value);

}