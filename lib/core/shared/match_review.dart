import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchReview extends StatelessWidget {

  final String team1, team2, result;
  //final Match match;
  final int leagueMatch;
  final DateTime matchDate;
  final double width;
  final Function onTap, onSettingsTap;

  MatchReview({
    @required this.team1,
    @required this.team2,
    @required this.result,
    @required this.leagueMatch,
    @required this.matchDate,
    @required this.width,
    this.onTap,
    this.onSettingsTap,
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
        width: width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/images/010-football.svg',
                  width: 24,
                  height: 24,
                  color: blueAgonisticaColor,
                ),
                Container(
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
                Icon(Icons.more_vert, color: blueAgonisticaColor,)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Text(
                    "Giornata $leagueMatch",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.calendar_today, color: blueAgonisticaColor,),
                      Text(
                        "${matchDate.day} " + Utils.monthToString(matchDate.month).substring(0, 4) + " ${matchDate.year}",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      )
                    ],
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