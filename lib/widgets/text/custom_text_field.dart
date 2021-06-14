import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CustomTextField extends StatelessWidget {

  final double? width;
  final TextEditingController? controller;
  final bool enabled;
  final bool readOnly;
  final TextAlign textAlign;
  final TextAlignVertical textAlignVertical;
  final int? maxLines;
  final TextInputType textInputType;
  final Color textColor;
  final double textFontSize;
  final FontWeight textFontWeight;
  final double bottomBorderPadding;
  final String? hint;

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
    this.hint,
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

  Widget _textField() {

    return PlatformTextField(
      enabled: enabled,
      readOnly: readOnly,
      textAlign: textAlign,
      textAlignVertical: textAlignVertical,
      autofocus: false,
      controller: controller,
      maxLines: maxLines,
      material: (_, __) => MaterialTextFieldData(
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.all(bottomBorderPadding),
            disabledBorder: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(
              color: textDisabledColor,
            )
          ),
      ),
      style: TextStyle(
//        color: showHint ? textDisabledColor : textColor,
        color: textColor,
        fontSize: textFontSize,
        fontWeight: textFontWeight,
      ),
      keyboardType: textInputType,
      inputFormatters: textInputFormatters(),
    );
  }

  List<TextInputFormatter> textInputFormatters() {
    List<TextInputFormatter> formatters = [];
    if(textInputType == TextInputType.number) {
      RegExp onlyDigits = RegExp(
        r"[0-9]",
        caseSensitive: false,
        multiLine: false,
      );
      formatters.add(FilteringTextInputFormatter.allow(onlyDigits));
    }
    return formatters;
  }

}