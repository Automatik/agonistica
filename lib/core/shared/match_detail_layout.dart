import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/shared/custom_rich_text.dart';
import 'package:agonistica/core/shared/custom_text_field.dart';
import 'package:agonistica/core/shared/edit_detail_button.dart';
import 'package:agonistica/core/shared/insert_team_dialog.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchDetailLayout extends StatefulWidget {

  final bool isNewMatch;
  final Match match;
  final double maxWidth;
  final List<Team> Function(String) onSuggestionTeamCallback;
  final Function(Match) onSave;

  MatchDetailLayout({
    @required this.isNewMatch,
    @required this.match,
    @required this.onSuggestionTeamCallback,
    @required this.onSave,
    this.maxWidth,
  }) : assert(match != null);

  @override
  State<StatefulWidget> createState() => _MatchDetailLayoutState();

}

class _MatchDetailLayoutState extends State<MatchDetailLayout> {

  final double teamsFontSize = 18;
  final FontWeight teamsFontWeight = FontWeight.bold;
  final Color teamsColor = Colors.black;

  final double matchFontSize = 16;
  final FontWeight matchFontWeight = FontWeight.normal;
  final Color matchFontColor = Colors.black;

  TextEditingController resultTextEditingController1, resultTextEditingController2,
      leagueMatchTextEditingController;

  bool editEnabled = true;

  // temp values
  Match tempMatch;
//  String tempTeam1Name, tempTeam2Name;
//  DateTime tempMatchDate;

  @override
  void initState() {
    super.initState();
    // if it's a new match enable already edit mode, otherwise start in view mode
    editEnabled = widget.isNewMatch;

    tempMatch = Match.clone(widget.match);
//    tempTeam1Name = widget.match.team1Name;
//    tempTeam2Name = widget.match.team2Name;
//    tempMatchDate = widget.match.matchDate;

    resultTextEditingController1 = TextEditingController();
    resultTextEditingController2 = TextEditingController();
    leagueMatchTextEditingController = TextEditingController();
    resultTextEditingController1.text = widget.match.team1Goals.toString();
    resultTextEditingController2.text = widget.match.team2Goals.toString();
    leagueMatchTextEditingController.text = widget.match.leagueMatch.toString();

  }

  void saveState() {
    if(editEnabled) {
      // saving new values

      //TODO Check if there are not textfields with errors

      //todo save team names (and eventually create new team and player objects)
      tempMatch.team1Goals = int.parse(resultTextEditingController1.text);
      tempMatch.team2Goals = int.parse(resultTextEditingController2.text);
      tempMatch.leagueMatch = int.parse(leagueMatchTextEditingController.text);
      widget.onSave(tempMatch);
//      widget.match.team1Name = tempTeam1Name;
//      widget.match.team2Name = tempTeam2Name;
//      widget.match.team1Goals = int.parse(resultTextEditingController1.text);
//      widget.match.team2Goals = int.parse(resultTextEditingController2.text);
//      widget.match.leagueMatch = int.parse(leagueMatchTextEditingController.text);
//      widget.match.matchDate = tempMatchDate;

    }
    setState(() {
      editEnabled = !editEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: widget.maxWidth,
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  margin: EdgeInsets.only(top: 20, bottom: 20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 12, right: 5, top: 10),
                            child: SvgPicture.asset(
                              'assets/images/010-football.svg',
                              width: 24,
                              height: 24,
                              color: blueAgonisticaColor,
                            ),
                          ),
                          Expanded(
                            child: Container(
                                margin: EdgeInsets.only(top: 10, right: 20),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: CustomRichText(
                                        onTap: () async {
                                          if(editEnabled) {
                                            Team team1 = await _showInsertTeamDialog(tempMatch.team1Name);
                                            if(team1 != null) {
                                              setState(() {
                                                tempMatch.setTeam1(team1);
                                              });
                                            }
                                          }
                                        },
                                        enabled: editEnabled,
                                        text: tempMatch.team1Name,
                                        textAlign: TextAlign.center,
                                        fontColor: teamsColor,
                                        fontWeight: teamsFontWeight,
                                        fontSize: teamsFontSize,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: resultWidget(resultTextEditingController1, resultTextEditingController2, teamsColor, teamsFontSize, teamsFontWeight, editEnabled),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: CustomRichText(
                                        onTap: () async {
                                          if(editEnabled) {
                                            Team team2 = await _showInsertTeamDialog(tempMatch.team2Name);
                                            if(team2 != null) {
                                              setState(() {
                                                tempMatch.setTeam2(team2);
                                              });
                                            }
                                          }
                                        },
                                        enabled: editEnabled,
                                        text: tempMatch.team2Name,
                                        textAlign: TextAlign.center,
                                        fontColor: teamsColor,
                                        fontWeight: teamsFontWeight,
                                        fontSize: teamsFontSize,
                                      ),
                                    ),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.only(left: 12, top: 10, bottom: 10),
                              child: Row(
                                children: [
                                  Text(
                                    'Giornata',
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: matchFontColor,
                                      fontWeight: matchFontWeight,
                                      fontSize: matchFontSize,
                                    ),
                                  ),
                                  SizedBox(width: 5,),
                                  CustomTextField(
                                    enabled: editEnabled,
                                    width: 50,
                                    controller: leagueMatchTextEditingController,
                                    textAlign: TextAlign.center,
                                    textAlignVertical: TextAlignVertical.top,
                                    maxLines: 1,
                                    textInputType: TextInputType.number,
                                    textColor: matchFontColor,
                                    textFontSize: matchFontSize,
                                    textFontWeight: matchFontWeight,
                                    bottomBorderPadding: 1,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: () async {
                                if(editEnabled) {
                                  DateTime curDate = DateTime.now();
                                  await showDatePicker(
                                      context: context,
                                      initialDate: tempMatch.matchDate,
                                      firstDate: DateTime.utc(2020),
                                      lastDate: DateTime.utc(curDate.year + 1),
                                      initialDatePickerMode: DatePickerMode.day,
                                      helpText: "Seleziona la data della partita"
                                  ).then((date) {
                                    if(date != null)
                                      setState(() {
                                        tempMatch.matchDate = date;
                                      });
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 15, top: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(Icons.calendar_today, color: blueAgonisticaColor, size: 20,),
                                    SizedBox(width: 5,),
                                    Text(
                                      "${tempMatch.matchDate.day} " + Utils.monthToString(tempMatch.matchDate.month).substring(0, 4) + " ${tempMatch.matchDate.year}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        color: matchFontColor,
                                        fontSize: matchFontSize,
                                        fontWeight: matchFontWeight,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                EditDetailButton(
                  isEditEnabled: editEnabled,
                  onTap: () => saveState(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<Team> _showInsertTeamDialog(String tempTeamName) async {
    Team tempTeam;
    InsertTeamDialog insertTeamDialog = InsertTeamDialog(
        initialValue: tempTeamName,
        maxHeight: MediaQuery.of(context).size.height,
        suggestionCallback: (pattern) {
          return widget.onSuggestionTeamCallback(pattern);
        },
        onSubmit: (finalTeamValue) {
          Navigator.of(context).pop();
          if(finalTeamValue != null) {
//            setState(() {
//              tempTeamName = finalValue;
//            });
            tempTeam = finalTeamValue;
          }
        }
    );
    await insertTeamDialog.showInsertTeamDialog(context);
//    return tempTeamName;
    return tempTeam;
  }

  Widget resultWidget(TextEditingController controller1, TextEditingController controller2, Color fontColor, double fontSize, FontWeight fontWeight, bool enabled) {
    return Row(
      children: [
        CustomTextField(
          enabled: enabled,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: controller1,
          maxLines: 1,
          textInputType: TextInputType.number,
          textColor: fontColor,
          textFontSize: fontSize,
          textFontWeight: fontWeight,
          bottomBorderPadding: 1,
        ),
        Text(
          '-',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
        CustomTextField(
          enabled: enabled,
          textAlign: TextAlign.center,
          textAlignVertical: TextAlignVertical.center,
          controller: controller2,
          maxLines: 1,
          textInputType: TextInputType.number,
          textColor: fontColor,
          textFontSize: fontSize,
          textFontWeight: fontWeight,
          bottomBorderPadding: 1,
        ),
      ],
    );
  }

}