import 'package:flutter/material.dart';

class CustomRichText extends StatelessWidget {

  final bool enabled;
  final String text;
  final TextAlign textAlign;
  final Color fontColor;
  final FontWeight fontWeight;
  final double fontSize;
  final EdgeInsetsGeometry margins;
  final Function onTap;

  CustomRichText({
    this.enabled = false,
    this.text,
    this.textAlign = TextAlign.center,
    this.fontSize = 18,
    this.fontWeight = FontWeight.normal,
    this.fontColor = Colors.black,
    this.margins,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margins,
//        decoration: BoxDecoration(
//          border: Border(
//            bottom: BorderSide(
//              width: enabled ? 1 : 0,
//            )
//          )
//        ),
        child: Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            decoration: enabled ? TextDecoration.underline : null,
            color: fontColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }

}