// @dart=2.9

import 'package:agonistica/widgets/text_styles/image_menu_card_text_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EmptyMenuCard extends StatelessWidget {

  final String title;
  final double width;
  final double height;
  final Function onTap;

  EmptyMenuCard({
    @required this.title,
    @required this.width,
    @required this.height,
    this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white, width: 1.5)
        ),
        child: content(),
      ),
    );
  }

  Widget content() {
    return Container(
      alignment: Alignment.center,
      width: width,
      height: height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          addIcon(),
          titleText()
        ],
      ),
    );
  }

  Widget addIcon() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 1.5),
        shape: BoxShape.circle
      ),
      child: Icon(
        Icons.add,
        color: Colors.white,
        size: 40,
      ),
    );
  }

  Widget titleText() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        textAlign: TextAlign.start,
        style: ImageMenuCardTextStyle(),
      ),
    );
  }

}