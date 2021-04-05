import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {

  static const int int64MaxValue = 9223372036854775807;

  final bool isEnabled;
  final TextEditingController controller;
  final bool autofocus;
  final TextAlign textAlign;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;
  final int minLines;
  final int maxLines;
  final double minHeight;

  TextBox({
    @required this.isEnabled,
    @required this.controller,
    this.autofocus = true,
    this.textAlign = TextAlign.start,
    this.fontSize = 16,
    this.fontColor = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.minLines = 15,
    this.maxLines = int64MaxValue,
    this.minHeight = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      constraints: BoxConstraints(
        minHeight: minHeight,
      ),
      child: TextField(
        enabled: isEnabled,
        autofocus: autofocus,
        controller: controller,
        textAlign: textAlign,
        style: TextStyle(
          color: fontColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        minLines: minLines,
        maxLines: maxLines,
        textInputAction: TextInputAction.newline,
        keyboardType: TextInputType.multiline,
      ),
    );
  }

}