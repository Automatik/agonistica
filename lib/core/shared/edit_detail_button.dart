import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class EditDetailButton extends StatelessWidget {

  final bool isEditEnabled;
  final Color backgroundColor;
  final Color iconColor;
  final Function onTap;

  EditDetailButton({
    @required this.isEditEnabled,
    this.backgroundColor = blueAgonisticaColor,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(top: 10, right: 0), //left: 340
          padding: EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: Icon(
            isEditEnabled ? context.platformIcons.checkMark : context.platformIcons.pen,
            size: 24,
            color: iconColor,
          ),
        ),
      ),
    );
  }

}