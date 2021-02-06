import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayerTextFormField extends StatelessWidget {

  final double labelIconSize = 24;

  final TextEditingController controller;
  final String labelText;
  final String labelSvgIconPath;
  final Function(String) onChanged;
  final Function(String) validator;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;
  final int maxErrorLines;
  final TextInputType textInputType;

  PlayerTextFormField({
    @required this.controller,
    this.labelText,
    this.labelSvgIconPath,
    this.onChanged,
    this.validator,
    this.fontSize,
    this.fontColor,
    this.fontWeight,
    this.maxErrorLines,
    this.textInputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {

    InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: blueAgonisticaColor),
    );

    Widget label;
    if(labelText != null) {
      label = labelTextWidget();
    } else {
      label = labelIconWidget();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8),
          child: label,
        ),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            enabledBorder: border,
            border: border,
            focusedBorder: border,
            errorMaxLines: maxErrorLines,
          ),
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: fontColor,
          ),
          autofocus: false,
          keyboardType: textInputType,
          onChanged: (value) => onChanged(value),
          validator: (value) => validator(value),
        ),
      ],
    );
  }

  Widget labelTextWidget() {
    return  Container(
      alignment: Alignment.centerLeft,
      height: labelIconSize,
      padding: const EdgeInsets.only(left: 5),
      child: Text(
        labelText,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: fontColor,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget labelIconWidget() {
    return Container(
      width: labelIconSize,
      height: labelIconSize,
      child: SvgPicture.asset(labelSvgIconPath)
    );
  }

}