import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

class PopupMenuItemTile extends StatelessWidget {

  final String text;
  final IconData iconData;
  final double fontSize;
  final Color fontColor;

  PopupMenuItemTile({
    @required this.text,
    @required this.iconData,
    this.fontSize = 16,
    this.fontColor = blueAgonisticaColor,
  }) : assert(text != null),
        assert(iconData != null);


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2.5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Text(
                text,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: fontSize,
                  color: fontColor,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            child: Icon(
              iconData,
              color: fontColor,
            ),
          ),
        ],
      ),
    );
  }

}