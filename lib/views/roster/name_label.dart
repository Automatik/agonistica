import 'package:agonistica/widgets/text/custom_text_field.dart';
import 'package:flutter/material.dart';

class NameLabel extends StatelessWidget{

  final TextEditingController nameTextController;
  final TextEditingController surnameTextController;
  final bool isEditEnabled;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;

  NameLabel({
    @required this.nameTextController,
    @required this.surnameTextController,
    @required this.isEditEnabled,
    @required this.fontColor,
    @required this.fontSize,
    @required this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    if(isEditEnabled) {
      return editingModeWidget(context);
    }
    return viewModeWidget(context);
  }

  Widget editingModeWidget(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomTextField(
          enabled: isEditEnabled,
          controller: nameTextController,
          textAlign: TextAlign.start,
          maxLines: 1,
          textInputType: TextInputType.text,
          textColor: fontColor,
          textFontSize: fontSize,
          textFontWeight: fontWeight,
        ),
        SizedBox(width: 5,),
        CustomTextField(
          enabled: isEditEnabled,
          controller: surnameTextController,
          textAlign: TextAlign.start,
          maxLines: 1,
          textInputType: TextInputType.text,
          textColor: fontColor,
          textFontSize: fontSize,
          textFontWeight: fontWeight,
        ),
      ],
    );
  }

  Widget viewModeWidget(BuildContext context) {
    return Text(
      "${nameTextController.text} ${surnameTextController.text}",
      textAlign: TextAlign.start,
      style: TextStyle(
        color: fontColor,
        fontWeight: fontWeight,
        fontSize: fontSize,
      ),
    );
  }

}