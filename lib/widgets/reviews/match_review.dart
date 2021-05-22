import 'package:agonistica/core/assets/team_assets.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:agonistica/widgets/images/svg_image.dart';
import 'package:agonistica/widgets/text_styles/match_review_result_text_style.dart';
import 'package:agonistica/widgets/text_styles/match_review_subtitle_text_style.dart';
import 'package:agonistica/widgets/text_styles/match_review_team_text_style.dart';
import 'package:flutter/material.dart';

class MatchReview extends StatelessWidget {

  final String team1, team2, result;
  final int leagueMatch;
  final DateTime matchDate;
  final double width, minHeight;
  final Function onTap, onSettingsTap;

  final double iconsSize = 24;
  final double teamImageSize = 40;
  final double topMargin = 10;
  final double bottomMargin = 10;

  MatchReview({
    @required this.team1,
    @required this.team2,
    @required this.result,
    @required this.leagueMatch,
    @required this.matchDate,
    @required this.width,
    this.minHeight = 50,
    this.onTap,
    this.onSettingsTap,
  }) : assert(team1 != null),
       assert(team2 != null),
       assert(result != null),
       assert(leagueMatch != null),
       assert(matchDate != null);

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            mainRow(),
            secondRow(),
          ],
        ),
      ),
    );
  }

  Widget mainRow() {
    return Row(
      children: [
        homeTeamWidget(),
        teamNameWidget(team1),
        resultWidget(result),
        teamNameWidget(team2),
        awayTeamWidget(),
      ],
    );
  }

  Widget secondRow() {
    return Row(
      children: [
        leagueMatchWidget(),
        matchDateWidget(),
        settingsWidget(),
      ],
    );
  }

  Widget homeTeamWidget() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 5, top: topMargin),
      child: SvgImage(
        imageAsset: TeamAssets.getRandomImage(),
        width: teamImageSize,
        height: teamImageSize,
      ),
    );
  }

  Widget teamNameWidget(String teamName) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 5, top: topMargin, right: 5),
        alignment: Alignment.center,
        child: Text(
          teamName,
          textAlign: TextAlign.center,
          style: MatchReviewTeamTextStyle(),
        ),
      ),
    );
  }

  Widget resultWidget(String result) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 5, top: topMargin, right: 5),
        alignment: Alignment.center,
        child: Text(
          result,
          textAlign: TextAlign.center,
          style: MatchReviewResultTextStyle(),
        ),
      )
    );
  }

  Widget awayTeamWidget() {
    return Container(
      margin: EdgeInsets.only(left: 5, right: 15, top: topMargin),
      child: SvgImage(
        imageAsset: TeamAssets.getRandomImage(),
        width: teamImageSize,
        height: teamImageSize,
      ),
    );
  }

  Widget leagueMatchWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 15, top: topMargin, bottom: bottomMargin),
        child: Text(
          "Giornata $leagueMatch",
          textAlign: TextAlign.start,
          style: MatchReviewSubtitleTextStyle(),
        ),
      ),
    );
  }

  Widget matchDateWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 5, top: topMargin, bottom: bottomMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.calendar_today, color: blueAgonisticaColor, size: iconsSize,),
            SizedBox(width: 5,),
            Text(
              "${matchDate.day} " + DateUtils.monthToString(matchDate.month).substring(0, 3) + " ${matchDate.year}",
              textAlign: TextAlign.center,
              style: MatchReviewSubtitleTextStyle(),
            )
          ],
        ),
      ),
    );
  }

  Widget settingsWidget() {
    return GestureDetector(
      onTapDown: (tapDetails) => onSettingsTap(tapDetails.globalPosition),
      child: Container(
          margin: EdgeInsets.only(left: 5, right: 15, top: topMargin, bottom: bottomMargin),
          child: Icon(Icons.more_vert, color: blueAgonisticaColor, size: iconsSize,)
      ),
    );
  }

}