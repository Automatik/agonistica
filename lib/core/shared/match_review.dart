import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchReview extends StatelessWidget {

  final String team1, team2, result;
  //final Match match;
  final int leagueMatch;
  final DateTime matchDate;
  final double width, minHeight;
  final Function onTap, onSettingsTap;

  final double iconsSize = 20;
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
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12, right: 5, top: topMargin),
                  width: iconsSize,
                  height: iconsSize,
                  child: SvgPicture.asset(
                    'assets/images/010-football.svg',
                    width: iconsSize,
                    height: iconsSize,
                    excludeFromSemantics: true,
                    color: blueAgonisticaColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: topMargin),
                    alignment: Alignment.center,
                    child: Text(
                      team1 + " " + result + " " + team2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 5, right: 12, top: topMargin),
                  child: Icon(Icons.more_vert, color: blueAgonisticaColor, size: iconsSize,)
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 12, top: topMargin, bottom: bottomMargin),
                    child: Text(
                      "Giornata $leagueMatch",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 15, top: topMargin, bottom: bottomMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.calendar_today, color: blueAgonisticaColor, size: iconsSize,),
                        SizedBox(width: 5,),
                        Text(
                          "${matchDate.day} " + DateUtils.monthToString(matchDate.month).substring(0, 3) + " ${matchDate.year}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}