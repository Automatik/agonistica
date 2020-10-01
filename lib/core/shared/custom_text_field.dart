import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomTextField extends StatelessWidget {

  final double width;
  final TextEditingController controller;
  final bool enabled;
  final bool readOnly;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final int maxLines;
  final TextInputType textInputType;
  final Color textColor;
  final double textFontSize;
  final FontWeight textFontWeight;
  final double bottomBorderPadding;

  CustomTextField({
    this.width,
    this.controller,
    this.enabled = true,
    this.readOnly = false,
    this.textAlign = TextAlign.center,
    this.textAlignVertical = TextAlignVertical.center,
    this.textColor = Colors.black,
    this.textFontSize = 18,
    this.textFontWeight = FontWeight.normal,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.bottomBorderPadding = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    if(width == null) {
      return Flexible(
        child: _textField(),
      );
    } else {
      return Container(
        width: width,
        child: _textField(),
      );
    }
  }

  //TODO Add input validation, especially for number (remove , . - space)
  Widget _textField() {
    return PlatformTextField(
      enabled: enabled,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.top,
      autofocus: false,
      controller: controller,
      maxLines: 1,
      material: (_, __) => MaterialTextFieldData(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(bottomBorderPadding),
            disabledBorder: InputBorder.none,
          )
      ),
      style: TextStyle(
        color: textColor,
        fontSize: textFontSize,
        fontWeight: textFontWeight,
      ),
      keyboardType: TextInputType.number,
    );
  }

}