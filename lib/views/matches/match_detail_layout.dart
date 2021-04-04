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
import 'package:agonistica/core/shared/text_box.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:agonistica/core/utils/my_snackbar.dart';
import 'package:agonistica/views/matches/change_team_dialog.dart';
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
  final Function(String) onViewPlayerCardCallback;

  MatchDetailLayout({
    @required this.match,
    @required this.isEditEnabled,
    @required this.controller,
    @required this.onTeamSuggestionCallback,
    @required this.onTeamInserted,
    @required this.onPlayersSuggestionCallback,
    @required this.onViewPlayerCardCallback,
    this.maxWidth,
  }) : assert(match != null);

  @override
  State<StatefulWidget> createState() => _MatchDetailLayoutState(controller);

}

class _MatchDetailLayoutState extends State<MatchDetailLayout> {

  bool editEnabled;

  // temp values
  Match tempMatch;

  TextEditingController resultTextEditingController1, resultTextEditingController2,
      leagueMatchTextEditingController, notesTextEditingController;

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
    notesTextEditingController = TextEditingController();

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
    notesTextEditingController.text = widget.match.matchNotes;
  }

  void updateMatchObjects() {
    tempMatch = widget.match;
  }

  void preloadTeams() {
    String homeTeamId = tempMatch.getHomeTeamId();
    String awayTeamId = tempMatch.getAwayTeamId();
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
    tempMatch.matchNotes = notesTextEditingController.text;

    removeEmptyPlayers();

    return true;
  }

  /// Remove empty players from match's playersData. The saveMatch in
  /// databaseService is creating a Player object for every player inserted in
  /// the match and it can't do that with empty MatchPlayerData. This causes
  /// next time the match view is open to display in different positions the
  /// existing players, because no empty player is shown
  void removeEmptyPlayers() {
    tempMatch.playersData.removeWhere((p) => p.isEmptyPlayer());
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
    return isTeam1Inserted() && isTeam2Inserted();
  }

  bool isTeam1Populated() {
    return isTeam1Inserted() && tempMatch.getHomePlayers().length > 0;
  }

  bool isTeam2Populated() {
    return isTeam2Inserted() && tempMatch.getAwayPlayers().length > 0;
  }

  bool isTeam1Inserted() {
    return tempMatch.team1Id != null;
  }

  bool isTeam2Inserted() {
    return tempMatch.team2Id != null;
  }

  /// Check if the edited player does not contain the same shirt number of other
  /// players in the same team, beside himself. This allows to have more players
  /// with the same name and surname
  bool validatePlayerShirtNumber(String matchPlayerDataId, int shirtNumber, bool isHomeTeam) {
    List<MatchPlayerData> homePlayers = tempMatch.getHomePlayers();
    List<MatchPlayerData> awayPlayers = tempMatch.getAwayPlayers();
    List<MatchPlayerData> teamPlayers = isHomeTeam ? homePlayers : awayPlayers;
    int index;
    // if the player is already defined in the match, so the playerId must be removed from the results
    index = teamPlayers.indexWhere((p) => p.id != matchPlayerDataId && p.shirtNumber == shirtNumber);
    bool isAnotherPlayerWithSameParameters = index != -1;
    return !isAnotherPlayerWithSameParameters;
  }

  Future<void> updateTeam1OnInsert(BuildContext context, bool isEditEnabled, Match match) async {
    if(isEditEnabled) {
      Team team1;
      String oldTeam1Id = match.team1Id;
      bool isTeamPopulated = isTeam1Populated();
      if(isTeamPopulated) {
        team1 = await updateTeamDialog(context, match.team1Name);
      } else {
        team1 = await updateTeamOnInsert(context, match.team1Name);
      }
      if(team1 != null) {
        if(isTeamPopulated) {
          removeTeamPlayersFromMatch(match, oldTeam1Id);
        }
        setState(() {
          match.setTeam1(team1);
        });
      }
    }
  }

  Future<void> updateTeam2OnInsert(BuildContext context, bool isEditEnabled, Match match) async {
    if(isEditEnabled) {
      Team team2;
      String oldTeam2Id = match.team2Id;
      bool isTeamPopulated = isTeam2Populated();
      if(isTeamPopulated) {
        team2 = await updateTeamDialog(context, match.team2Name);
      } else {
        team2 = await updateTeamOnInsert(context, match.team2Name);
      }
      if(team2 != null) {
        if(isTeamPopulated) {
          removeTeamPlayersFromMatch(match, oldTeam2Id);
        }
        setState(() {
          match.setTeam2(team2);
        });
      }
    }
  }

  Future<Team> updateTeamDialog(BuildContext context, String teamName) async {
    Team team;
    final dialog = ChangeTeamDialog(
      onConfirm: () async {
        print("onConfirm");
        team = await updateTeamOnInsert(context, teamName);
        Navigator.of(context).pop();
      },
      onCancel: () => Navigator.of(context).pop(),
    );
    await dialog.showChangeTeamDialog(context);
    return team;
  }

  Future<Team> updateTeamOnInsert(BuildContext context, String teamName) async {
    Team team = await _showInsertTeamDialog(context, teamName);
    if(team != null) {
      widget.onTeamInserted(team.id);
    }
    return team;
  }

  /// Replace team players with an empty player
  void removeTeamPlayersFromMatch(Match match, String teamId) {
    List<MatchPlayerData> newPlayerDataList = List();
    match.playersData.forEach((p) {
      if(p.teamId == teamId) {
        p = MatchPlayerData.empty(teamId, isRegular: p.isRegular);
      }
      newPlayerDataList.add(p);
    });
    match.playersData = newPlayerDataList;
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
              matchCharacteristics(context, editEnabled),
              matchNotes(editEnabled),
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
      margin: EdgeInsets.only(top: 20, bottom: 10),
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
                            onTap: () => updateTeam1OnInsert(context, isEditEnabled, matchInfo),
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
                            onTap: () => updateTeam2OnInsert(context, isEditEnabled, matchInfo),
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
                          "${matchInfo.matchDate.day} " + DateUtils.monthToString(matchInfo.matchDate.month).substring(0, 3) + " ${matchInfo.matchDate.year}",
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

  Widget matchCharacteristics(BuildContext context, bool isEditEnabled) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(top: 10, bottom: 10),
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

  Widget matchNotes(bool isEditEnabled) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(top: 10, bottom: 20),
      child: Column(
        children: [
          lineUpText("Note Partita"),
          textBox(isEditEnabled),
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
    List<MatchPlayerData> homeRegularPlayers = tempMatch.getHomeRegularPlayers();
    List<MatchPlayerData> awayRegularPlayers = tempMatch.getAwayRegularPlayers();
    int numHomeRegularPlayers = homeRegularPlayers.length;
    int numAwayRegularPlayers = awayRegularPlayers.length;
    int numRegularPlayers = max(numHomeRegularPlayers, numAwayRegularPlayers);
    balanceTeamPlayers(homeRegularPlayers, numRegularPlayers, tempMatch.getHomeTeamId(), true);
    balanceTeamPlayers(awayRegularPlayers, numRegularPlayers, tempMatch.getAwayTeamId(), true);

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
    List<MatchPlayerData> homeReservePlayers = tempMatch.getHomeReservePlayers();
    List<MatchPlayerData> awayReservePlayers = tempMatch.getAwayReservePlayers();
    int numHomeReservePlayers = homeReservePlayers.length;
    int numAwayReservePlayers = awayReservePlayers.length;
    int numReservePlayers = max(numHomeReservePlayers, numAwayReservePlayers);
    balanceTeamPlayers(homeReservePlayers, numReservePlayers, tempMatch.getHomeTeamId(), false);
    balanceTeamPlayers(awayReservePlayers, numReservePlayers, tempMatch.getAwayTeamId(), false);

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
        primary: false, //prevent it from scrolling separately
        itemBuilder: (ctx, index) {
          if(_isRowWithPlayers(index, rowsCount, areRemainingRegularPlayersToFill)) {
            return PlayerItemsRow(
              homePlayer: homePlayers[index],
              awayPlayer: awayPlayers[index],
              isEditEnabled: isEditEnabled,
              lineSeparatorWidth: _getLineSeparatorWidth(index, rowsCount),
              onPlayerValidation: (id, shirtNumber, isHomePlayer) => validatePlayerShirtNumber(id, shirtNumber, isHomePlayer),
              onPlayerSuggestionCallback: (namePattern, surnamePattern, isHomePlayer) {
                String teamId = isHomePlayer ? tempMatch.team1Id : tempMatch.team2Id;
                List<Player> players = widget.onPlayersSuggestionCallback(namePattern, surnamePattern, teamId);
                // Remove players already in the lineup
                List<String> lineupPlayersIds = tempMatch.playersData.map((p) => p.playerId).toList();
                players.removeWhere((p) => lineupPlayersIds.contains(p.id));
                return players;
              },
              onSaveCallback: (matchPlayerData, isHomePlayer) {
                setState(() {
                  _replacePlayerUsingId(tempMatch.playersData, matchPlayerData);
                });
              },
              onViewPlayerCardCallback: (matchPlayerData) => widget.onViewPlayerCardCallback(matchPlayerData.playerId),
              onDeleteCallback: (matchPlayerData, isHomePlayer) {
                setState(() {
                  tempMatch.playersData.remove(matchPlayerData);
                });
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

  Widget textBox(bool isEditEnabled) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: isEditEnabled ? 0.5 : 0,
          color: blueAgonisticaColor
        ),
      ),
      child: TextBox(
        isEnabled: isEditEnabled,
        controller: notesTextEditingController,
        autofocus: false,
        minLines: 5,
      ),
    );
  }

  /// Replace in the List of MatchPlayerData the empty MatchPlayerData with the
  /// new MatchPlayerData using the MatchPlayerData's id to identify it
  void _replacePlayerUsingId(List<MatchPlayerData> players, MatchPlayerData player) {
    String id = player.id;
    int index = players.indexWhere((p) => p.id == id);
    if(index == -1) {
      // MatchPlayerData with id not found in the list of MatchPlayerData
      players.add(player);
      return;
    }
    players[index] = player;
  }

  bool _isRowWithPlayers(int rowIndex, int numRows, bool areRemainingRegularPlayersToFill) {
    bool isLastRow = rowIndex == numRows - 1;
    bool isRowWithNoPlayers = isLastRow && areRemainingRegularPlayersToFill;
    return !isRowWithNoPlayers;
  }

  void balanceTeamPlayers(List<MatchPlayerData> players, int numPlayersToReach, String teamId, bool areRegulars) {
    int originalLength = players.length;
    if(numPlayersToReach <= originalLength)
      return;
    players.length = numPlayersToReach;
    players.fillRange(originalLength, numPlayersToReach, areRegulars ? _addRegularPlayer(teamId) : _addReservePlayer(teamId));
  }

  void _addNewRowWithRegularPlayers() {
    MatchPlayerData newHomePlayer = _addRegularPlayer(tempMatch.getHomeTeamId());
    MatchPlayerData newAwayPlayer = _addRegularPlayer(tempMatch.getAwayTeamId());
    _addNewRow(newHomePlayer, newAwayPlayer);
  }

  void _addNewRowWithReservePlayers() {
    MatchPlayerData newHomePlayer = _addReservePlayer(tempMatch.getHomeTeamId());
    MatchPlayerData newAwayPlayer = _addReservePlayer(tempMatch.getAwayTeamId());
    _addNewRow(newHomePlayer, newAwayPlayer);
  }

  MatchPlayerData _addRegularPlayer(String teamId) {
    return MatchPlayerData.empty(teamId, isRegular: true);
  }

  MatchPlayerData _addReservePlayer(String teamId) {
    return MatchPlayerData.empty(teamId, isRegular: false);
  }

  void _addNewRow(MatchPlayerData newHomePlayer, MatchPlayerData newAwayPlayer) {
    setState(() {
      tempMatch.playersData.add(newHomePlayer);
      tempMatch.playersData.add(newAwayPlayer);
    });
  }

  double _getLineSeparatorWidth(int index, int rowsCount) {
    return index == 0 || index == rowsCount - 1 ? 0 : 0.5;
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