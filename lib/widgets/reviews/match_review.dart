import 'package:agonistica/core/assets/team_assets.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:agonistica/widgets/images/svg_image.dart';
import 'package:agonistica/widgets/reviews/base_review.dart';
import 'package:agonistica/widgets/text_styles/base_review_result_text_style.dart';
import 'package:agonistica/widgets/text_styles/base_review_subtitle_text_style.dart';
import 'package:agonistica/widgets/text_styles/base_review_team_text_style.dart';
import 'package:flutter/material.dart';

class MatchReview extends BaseReview {

  final String team1, team2, result;
  final int leagueMatch;
  final DateTime matchDate;

  MatchReview({
    @required this.team1,
    @required this.team2,
    @required this.result,
    @required this.leagueMatch,
    @required this.matchDate,
    @required width,
    minHeight = 50.0,
    onTap,
    onSettingsTap,
  }) : assert(team1 != null),
        assert(team2 != null),
        assert(result != null),
        assert(leagueMatch != null),
        assert(matchDate != null),
        super(width: width, minHeight: minHeight, onTap: onTap, onSettingsTap: onSettingsTap);


  @override
  Widget content() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        mainRow(),
        secondRow(),
      ],
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
    return Container(
      margin: EdgeInsets.only(top: verticalMargin),
      child: Row(
        children: [
          leagueMatchWidget(),
          matchDateWidget(),
          settingsWidget(),
        ],
      ),
    );
  }

  Widget homeTeamWidget() {
    return Container(
      margin: EdgeInsets.only(right: 5),
      child: SvgImage(
        imageAsset: TeamAssets.getRandomImage(),
        width: avatarSize,
        height: avatarSize,
      ),
    );
  }

  Widget teamNameWidget(String teamName) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        alignment: Alignment.center,
        child: Text(
          teamName,
          textAlign: TextAlign.center,
          style: BaseReviewTeamTextStyle(),
        ),
      ),
    );
  }

  Widget resultWidget(String result) {
    return Expanded(
        child: Container(
          margin: EdgeInsets.only(left: 5, right: 5),
          alignment: Alignment.center,
          child: Text(
            result,
            textAlign: TextAlign.center,
            style: BaseReviewResultTextStyle(),
          ),
        )
    );
  }

  Widget awayTeamWidget() {
    return Container(
      margin: EdgeInsets.only(left: 5),
      child: SvgImage(
        imageAsset: TeamAssets.getRandomImage(),
        width: avatarSize,
        height: avatarSize,
      ),
    );
  }

  Widget leagueMatchWidget() {
    return Expanded(
      child: Container(
        child: Text(
          "Giornata $leagueMatch",
          textAlign: TextAlign.start,
          style: BaseReviewSubtitleTextStyle(),
        ),
      ),
    );
  }

  Widget matchDateWidget() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(right: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.calendar_today, color: blueAgonisticaColor, size: iconsSize,),
            SizedBox(width: 5,),
            Text(
              "${matchDate.day} " + DateUtils.monthToString(matchDate.month).substring(0, 3) + " ${matchDate.year}",
              textAlign: TextAlign.center,
              style: BaseReviewSubtitleTextStyle(),
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
          margin: EdgeInsets.only(left: 5),
          child: Icon(Icons.more_vert, color: blueAgonisticaColor, size: iconsSize,)
      ),
    );
  }

}