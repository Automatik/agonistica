// @dart=2.9

import 'package:agonistica/widgets/text_styles/season_card_text_style.dart';
import 'package:flutter/material.dart';

class SeasonCard extends StatelessWidget {

  String title;
  double height;
  Function onTap;

  SeasonCard({
    @required this.title,
    this.height = 100,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      alignment: Alignment.center,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white.withAlpha(128), Colors.white24.withAlpha(128)]
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: SeasonCardTextStyle(),
      ),
    );
  }



}