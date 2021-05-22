import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/images/svg_image.dart';
import 'package:agonistica/widgets/text_styles/match_review_subtitle_text_style.dart';
import 'package:agonistica/widgets/text_styles/match_review_team_text_style.dart';
import 'package:flutter/material.dart';

import '../../core/utils/date_utils.dart';

class PlayerReview extends StatelessWidget{

  final String name, role;
  final DateTime birthDay;
  final double width, minHeight;
  final Function onTap, onSettingsTap;

  final double iconsSize = 24;
  final double playerIconSize = 40;
  final double topMargin = 10;
  final double bottomMargin = 10;

  PlayerReview({
    this.name,
    this.role,
    this.birthDay,
    this.width,
    this.minHeight = 50,
    this.onTap,
    this.onSettingsTap
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          maxWidth: width,
          minHeight: minHeight,
        ),
        child: Row(
          children: [
            playerImage(),
            Expanded(
              child: Column(
                children: [
                  topRow(),
                  bottomRow()
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  Widget playerImage() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(200),
        borderRadius: BorderRadius.circular(32),
      ),
      alignment: Alignment.center,
      child: SvgImage(
        imageAsset: IconAssets.ICON_FOOTBALL_PLAYER,
        width: playerIconSize,
        height: playerIconSize,
      ),
    );
  }

  Widget topRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Container(
              child: Text(
                name,
                textAlign: TextAlign.start,
                style: MatchReviewTeamTextStyle(),
              ),
            ),
          ),
          GestureDetector(
              onTapDown: (tapDetails) => onSettingsTap(tapDetails.globalPosition),
              child: Container(
                  child: Icon(Icons.more_vert, color: blueAgonisticaColor, size: iconsSize,)
              ),
          ),
        ],
      ),
    );
  }

  Widget bottomRow() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
      child: Row(
        children: [
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(left: 12, top: topMargin, bottom: bottomMargin),
              child: Text(
                role,
                textAlign: TextAlign.start,
                style: MatchReviewSubtitleTextStyle(),
              ),
            ),
          ),
          Expanded(
            child: Container(
              // margin: EdgeInsets.only(right: 15, top: topMargin, bottom: bottomMargin),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.calendar_today, color: blueAgonisticaColor, size: iconsSize,),
                  SizedBox(width: 5,),
                  Text(
                    "${birthDay.day} " + DateUtils.monthToString(birthDay.month).substring(0, 3) + " ${birthDay.year}",
                    textAlign: TextAlign.end,
                    style: MatchReviewSubtitleTextStyle(),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}