import 'dart:math';

import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/services/base_scaffold_service.dart';
import 'package:agonistica/core/shared/custom_rich_text.dart';
import 'package:agonistica/core/shared/custom_text_field.dart';
import 'package:agonistica/core/shared/insert_team_dialog.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:agonistica/core/utils/my_snackbar.dart';
import 'package:agonistica/views/matches/player_items_empty_row.dart';
import 'package:agonistica/views/matches/player_items_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const int MAX_REGULARS_PLAYERS = 11;

class MatchDetailLayout extends StatefulWidget {

  static const String SNACKBAR_TEXT_SELECT_TEAMS = "Seleziona le squadre prima di modificare i giocatori";

  final Match match;
  final bool isEditEnabled;
  final double maxWidth;
  final MatchDetailController controller;
  final List<Team> Function(String) onTeamSuggestionCallback;
  final Function(String) onTeamInserted;
  final Function(String, String, String) onPlayersSuggestionCallback;

  MatchDetailLayout({
    @required this.match,
    @required this.isEditEnabled,
    @required this.controller,
    @required this.onTeamSuggestionCallback,
    @required this.onTeamInserted,
    @required this.onPlayersSuggestionCallback,
    this.maxWidth,
  }) : assert(match != null);

  @override
  State<StatefulWidget> createState() => _MatchDetailLayoutState(controller);

}

class _MatchDetailLayoutState extends State<MatchDetailLayout> {

  //TODO Se dopo aver selezionato le due squadre e inserito i giocatori, cambio una delle due squadre vanno tolti i giocatori di quella squadra, dato che non gli appartengono

  bool editEnabled;

  // temp values
  Match tempMatch;

  String homeTeamId, awayTeamId;
  List<MatchPlayerData> homePlayers, awayPlayers;

  TextEditingController resultTextEditingController1, resultTextEditingController2,
      leagueMatchTextEditingController;

  _MatchDetailLayoutState(MatchDetailController controller) {
    controller.saveMatchStatus = () => saveMatchState();
  }

  @override
  void initState() {
    super.initState();
    // if it's a new match enable already edit mode, otherwise start in view mode
    editEnabled = widget.isEditEnabled;

    resultTextEditingController1 = TextEditingController();
    resultTextEditingController2 = TextEditingController();
    leagueMatchTextEditingController = TextEditingController();

    updateMatchObjects();
    preloadTeams();
    reset();

  }

  @override
  void didUpdateWidget(covariant MatchDetailLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    editEnabled = widget.isEditEnabled;
    updateMatchObjects();
    if(oldWidget.isEditEnabled != widget.isEditEnabled)
      reset();
  }

  void reset() {
    resultTextEditingController1.text = widget.match.team1Goals.toString();
    resultTextEditingController2.text = widget.match.team2Goals.toString();
    leagueMatchTextEditingController.text = widget.match.leagueMatch.toString();
  }

  void updateMatchObjects() {
    tempMatch = widget.match;
    homeTeamId = widget.match.team1Id;
    awayTeamId = widget.match.team2Id;
    homePlayers = widget.match.playersData.where((e) => e.teamId == homeTeamId).toList();
    awayPlayers = widget.match.playersData.where((e) => e.teamId == awayTeamId).toList();
  }

  void preloadTeams() {
    if(homeTeamId != null)
      widget.onTeamInserted(homeTeamId);
    if(awayTeamId != null)
      widget.onTeamInserted(awayTeamId);
  }

  bool saveMatchState() {

    String errorMessage = validateTextFields();
    bool isError = errorMessage != null;
    if(isError) {
      final _baseScaffoldService = locator<BaseScaffoldService>();
      MySnackBar.showSnackBar(_baseScaffoldService.scaffoldContext, errorMessage);
      return false;
    }

    // teams' names and ids are already inserted from the InsertTeamDialog
    // match's date is already saved from dialog
    // players data is inserted with addNewRow method
    tempMatch.team1Goals = int.tryParse(resultTextEditingController1.text);
    tempMatch.team2Goals = int.tryParse(resultTextEditingController2.text);
    tempMatch.leagueMatch = int.tryParse(leagueMatchTextEditingController.text);

    return true;
  }

  String validateTextFields() {
    String errorMessage = InputValidation.validateTeamName(tempMatch.team1Name);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateTeamName(tempMatch.team2Name);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateResultGoal(resultTextEditingController1.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateResultGoal(resultTextEditingController2.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateLeagueMatch(leagueMatchTextEditingController.text);
    if(errorMessage != null) return errorMessage;
    return null;
  }

  bool userCanEditPlayers() {
    return areTeamsInserted() && editEnabled;
  }

  /// Return true if both teams have been selected or inserted
  bool areTeamsInserted() {
    String team1Id = tempMatch.team1Id;
    String team2Id = tempMatch.team2Id;
    return team1Id != null && team2Id != null;
  }

  /// Check if the edited player does not contain the same shirt number of other
  /// players in the same team, beside himself. This allows to have more players
  /// with the same name and surname
  bool validatePlayerShirtNumber(String playerId, int shirtNumber, bool isHomeTeam) {
    List<MatchPlayerData> teamPlayers = isHomeTeam ? homePlayers : awayPlayers;
    int index;
    if(playerId != null) {
      // the player is already defined in the match, so the playerId must be removed from the results
      index = teamPlayers.indexWhere((p) => p.playerId != playerId && p.shirtNumber == shirtNumber);
    } else {
      index = teamPlayers.indexWhere((p) => p.shirtNumber == shirtNumber);
    }
    bool isAnotherPlayerWithSameParameters = index != -1;
    return !isAnotherPlayerWithSameParameters;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          width: widget.maxWidth,
          child: Column(
            children: [
              matchInfo(context, tempMatch, editEnabled),
              matchCharacteristics(context, tempMatch, editEnabled),
            ],
          ),
        ),
      ),
    );
  }

  Widget matchInfo(BuildContext context, Match matchInfo, bool isEditEnabled) {

    final double teamsFontSize = 18;
    final FontWeight teamsFontWeight = FontWeight.bold;
    final Color teamsColor = Colors.black;

    final double matchFontSize = 16;
    final FontWeight matchFontWeight = FontWeight.normal;
    final Color matchFontColor = Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(top: 20),
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
                              if(isEditEnabled) {
                                Team team1 = await _showInsertTeamDialog(context, matchInfo.team1Name);
                                if(team1 != null) {
                                  setState(() {
                                    matchInfo.setTeam1(team1);
                                  });
                                  widget.onTeamInserted(team1.id);
                                }
                              }
                            },
                            enabled: isEditEnabled,
                            text: matchInfo.team1Name,
                            textAlign: TextAlign.center,
                            fontColor: teamsColor,
                            fontWeight: teamsFontWeight,
                            fontSize: teamsFontSize,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: resultWidget(resultTextEditingController1, resultTextEditingController2, teamsColor, teamsFontSize, teamsFontWeight, isEditEnabled),
                        ),
                        Expanded(
                          flex: 2,
                          child: CustomRichText(
                            onTap: () async {
                              if(isEditEnabled) {
                                Team team2 = await _showInsertTeamDialog(context, matchInfo.team2Name);
                                if(team2 != null) {
                                  setState(() {
                                    matchInfo.setTeam2(team2);
                                  });
                                  widget.onTeamInserted(team2.id);
                                }
                              }
                            },
                            enabled: isEditEnabled,
                            text: matchInfo.team2Name,
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
                        enabled: isEditEnabled,
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
                    if(isEditEnabled) {
                      DateTime curDate = DateTime.now();
                      await showDatePicker(
                          context: context,
                          initialDate: matchInfo.matchDate,
                          firstDate: DateTime.utc(2020),
                          lastDate: DateTime.utc(curDate.year + 1),
                          initialDatePickerMode: DatePickerMode.day,
                          helpText: "Seleziona la data della partita"
                      ).then((date) {
                        if(date != null)
                          setState(() {
                            matchInfo.matchDate = date;
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
                          "${matchInfo.matchDate.day} " + Utils.monthToString(matchInfo.matchDate.month).substring(0, 3) + " ${matchInfo.matchDate.year}",
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
    );
  }

  Widget matchCharacteristics(BuildContext context, Match matchInfo, bool isEditEnabled) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          lineUpText("Titolari"),
          regularPlayers(context, isEditEnabled),
          lineUpText("Riserve"),
          reservePlayers(context, isEditEnabled),
        ],
      ),
    );
  }

  Widget lineUpText(String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: blueAgonisticaColor,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget regularPlayers(BuildContext context, bool isEditEnabled) {
    List<MatchPlayerData> homeRegularPlayers = homePlayers.where((e) => e.isRegular).toList();
    List<MatchPlayerData> awayRegularPlayers = awayPlayers.where((e) => e.isRegular).toList();
    int numHomeRegularPlayers = homeRegularPlayers.length;
    int numAwayRegularPlayers = awayRegularPlayers.length;
    int numRegularPlayers = max(numHomeRegularPlayers, numAwayRegularPlayers);

    bool areRemainingRegularPlayersToFill;
    int rowsCount;
    if(isEditEnabled) {
      areRemainingRegularPlayersToFill = numRegularPlayers < MAX_REGULARS_PLAYERS;
      rowsCount = areRemainingRegularPlayersToFill ? numRegularPlayers + 1 : MAX_REGULARS_PLAYERS; //+1 to add the empty row
    } else {
      rowsCount = numRegularPlayers;
      areRemainingRegularPlayersToFill = false;
    }

    return listPlayers(homeRegularPlayers, awayRegularPlayers, rowsCount, areRemainingRegularPlayersToFill, isEditEnabled, true);
  }

  Widget reservePlayers(BuildContext context, bool isEditEnabled) {
    List<MatchPlayerData> homeReservePlayers = homePlayers.where((e) => !e.isRegular).toList();
    List<MatchPlayerData> awayReservePlayers = awayPlayers.where((e) => !e.isRegular).toList();
    int numHomeReservePlayers = homeReservePlayers.length;
    int numAwayReservePlayers = awayReservePlayers.length;
    int numReservePlayers = max(numHomeReservePlayers, numAwayReservePlayers);

    bool areRemainingRegularPlayersToFill;
    int rowsCount;
    if(isEditEnabled) {
      areRemainingRegularPlayersToFill = true;
      rowsCount = numReservePlayers + 1; //+1 to add the empty row
    } else {
      areRemainingRegularPlayersToFill = false;
      rowsCount = numReservePlayers;
    }

    return listPlayers(homeReservePlayers, awayReservePlayers, rowsCount, areRemainingRegularPlayersToFill, isEditEnabled, false);
  }

  Widget listPlayers(List<MatchPlayerData> homePlayers, List<MatchPlayerData> awayPlayers, int rowsCount, bool areRemainingRegularPlayersToFill, bool isEditEnabled, bool areRegulars) {
    return ListView.builder(
        itemCount: rowsCount,
        shrinkWrap: true,
        itemBuilder: (ctx, index) {
          if(_isRowWithPlayers(index, rowsCount, areRemainingRegularPlayersToFill)) {
            return PlayerItemsRow(
              homePlayer: homePlayers[index],
              awayPlayer: awayPlayers[index],
              isEditEnabled: isEditEnabled,
              onPlayerValidation: (playerId, shirtNumber, isHomePlayer) => validatePlayerShirtNumber(playerId, shirtNumber, isHomePlayer),
              onPlayerSuggestionCallback: (namePattern, surnamePattern, isHomePlayer) {
                String teamId = isHomePlayer ? tempMatch.team1Id : tempMatch.team2Id;
                List<Player> players = widget.onPlayersSuggestionCallback(namePattern, surnamePattern, teamId);
                // Remove players already in the lineup
                players.removeWhere((p) => isHomePlayer ? homePlayers.any((hp) => hp.playerId == p.id) : awayPlayers.any((ap) => ap.playerId == p.id));
                return players;
              },
            );
          } else {
            return PlayerItemsEmptyRow(
              onTap: () {
                if(userCanEditPlayers()) {
                  if(areRegulars) {
                    _addNewRowWithRegularPlayers();
                  } else {
                    _addNewRowWithReservePlayers();
                  }
                } else {
                  MySnackBar.showSnackBar(context, MatchDetailLayout.SNACKBAR_TEXT_SELECT_TEAMS);
                }
              },
            );
          }
        }
    );
  }

  bool _isRowWithPlayers(int rowIndex, int numRows, bool areRemainingRegularPlayersToFill) {
    bool isLastRow = rowIndex == numRows - 1;
    bool isRowWithNoPlayers = isLastRow && areRemainingRegularPlayersToFill;
    return !isRowWithNoPlayers;
  }

  void _addNewRowWithRegularPlayers() {
    MatchPlayerData newHomePlayer = MatchPlayerData.empty(homeTeamId, isRegular: true);
    MatchPlayerData newAwayPlayer = MatchPlayerData.empty(awayTeamId, isRegular: true);
    _addNewRow(newHomePlayer, newAwayPlayer);
  }

  void _addNewRowWithReservePlayers() {
    MatchPlayerData newHomePlayer = MatchPlayerData.empty(homeTeamId, isRegular: false);
    MatchPlayerData newAwayPlayer = MatchPlayerData.empty(awayTeamId, isRegular: false);
    _addNewRow(newHomePlayer, newAwayPlayer);
  }

  void _addNewRow(MatchPlayerData newHomePlayer, MatchPlayerData newAwayPlayer) {
    setState(() {
      tempMatch.playersData.add(newHomePlayer);
      tempMatch.playersData.add(newAwayPlayer);
      homePlayers.add(newHomePlayer);
      awayPlayers.add(newAwayPlayer);
    });
  }

  Future<Team> _showInsertTeamDialog(BuildContext context, String tempTeamName) async {
    Team tempTeam;
    InsertTeamDialog insertTeamDialog = InsertTeamDialog(
        initialValue: tempTeamName,
        maxHeight: MediaQuery.of(context).size.height,
        suggestionCallback: (pattern) {
          return widget.onTeamSuggestionCallback(pattern);
        },
        onSubmit: (finalTeamValue) {
          Navigator.of(context).pop();
          if(finalTeamValue != null) {
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

class MatchDetailController {

  bool Function() saveMatchStatus;

}