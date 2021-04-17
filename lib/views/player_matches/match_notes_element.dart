import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:agonistica/views/player_matches/match_notes_object.dart';
import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchNotesElement extends StatelessWidget {

  final MatchNotesObject object;
  final Function onTap;
  final double minHeight;
  final double width;

  final double iconsSize = 20;
  final double topMargin = 10;
  final double bottomMargin = 10;

  MatchNotesElement({
    this.object,
    this.onTap,
    this.minHeight,
    this.width,
  });

  @override
  Widget build(BuildContext context) {

    final match = object.match;
    final notes = object.notes;

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
                    excludeFromSemantics: true,
                    color: blueAgonisticaColor,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: topMargin),
                    alignment: Alignment.center,
                    child: Text(
                      "${match.getHomeSeasonTeamName()} ${match.team1Goals} - ${match.team2Goals} ${match.getAwaySeasonTeamName()}",
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
                      "Giornata ${match.leagueMatch}",
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
                          "${match.matchDate.day} " + DateUtils.monthToString(match.matchDate.month).substring(0, 3) + " ${match.matchDate.year}",
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

  Widget notesWidget(PlayerMatchNotes notes) {

    Color fontColor = Colors.black;
    double fontSize = 16;
    FontWeight fontWeight = FontWeight.normal;
    double verticalMargin = 10;

    if(notes == null) {
      // no notes exist for this match
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: verticalMargin),
          child: Text(
            "Nessuna nota per questa partita",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      );
    } else {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: EdgeInsets.symmetric(vertical: verticalMargin),
          child: ExpandText(
            notes.notes,
            textAlign: TextAlign.justify,
            style: TextStyle(
              color: fontColor,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            maxLines: 4,
            collapsedHint: "Espandi",
            expandedHint: "Collassa",
          ),
        ),
      );
    }
  }

}