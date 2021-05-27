import 'dart:math';
import 'package:agonistica/core/assets/image_assets.dart';
import 'package:agonistica/core/assets/team_assets.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/widgets/common/date_widget.dart';
import 'package:agonistica/widgets/images/svg_image.dart';
import 'package:agonistica/widgets/text/custom_rich_text.dart';
import 'package:agonistica/widgets/text/custom_text_field.dart';
import 'package:agonistica/widgets/dialogs/insert_team_dialog.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/text/text_box.dart';
import 'package:agonistica/core/utils/date_utils.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:agonistica/core/utils/my_snackbar.dart';
import 'package:agonistica/widgets/dialogs/change_team_dialog.dart';
import 'package:agonistica/views/matches/player_items_empty_row.dart';
import 'package:agonistica/views/matches/player_items_row.dart';
import 'package:agonistica/widgets/text_styles/detail_view_subtitle_text_style.dart';
import 'package:agonistica/widgets/text_styles/detail_view_title_text_style.dart';
import 'package:flutter/material.dart';

const int MAX_REGULARS_PLAYERS = 11;

class MatchDetailLayout extends StatefulWidget {

  static const String SNACKBAR_TEXT_SELECT_TEAMS = "Seleziona le squadre prima di modificare i giocatori";
  static const String INSERTED_TEAM_ERROR_ALREADY_INSERTED = "Squadra già inserita nella partita";

  static const double MATCH_INFO_HEIGHT = 250;
  static const double MATCH_INFO_LOGO_SIZE = 60;

  final Match match;
  final bool isEditEnabled;
  final double maxWidth;
  final MatchDetailController controller;
  final List<SeasonTeam> Function(String) onTeamSuggestionCallback;
  final Function(String) onTeamInserted;
  final Function(String, String, String) onPlayersSuggestionCallback;
  final Function(String) onViewPlayerCardCallback;
  final Function(Match, MatchPlayerData) onInsertNotesCallback;

  MatchDetailLayout({
    @required this.match,
    @required this.isEditEnabled,
    @required this.controller,
    @required this.onTeamSuggestionCallback,
    @required this.onTeamInserted,
    @required this.onPlayersSuggestionCallback,
    @required this.onViewPlayerCardCallback,
    @required this.onInsertNotesCallback,
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
    String homeTeamId = tempMatch.getHomeSeasonTeamId();
    String awayTeamId = tempMatch.getAwaySeasonTeamId();
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
    String errorMessage = InputValidation.validateTeamName(tempMatch.getHomeSeasonTeamName());
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateTeamName(tempMatch.getAwaySeasonTeamName());
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
    return isHomeTeamInserted() && isAwayTeamInserted();
  }

  bool isHomeTeamPopulated() {
    return isHomeTeamInserted() && tempMatch.getHomePlayers().length > 0;
  }

  bool isAwayTeamPopulated() {
    return isAwayTeamInserted() && tempMatch.getAwayPlayers().length > 0;
  }

  bool isHomeTeamInserted() {
    return tempMatch.seasonTeam1Id != null;
  }

  bool isAwayTeamInserted() {
    return tempMatch.seasonTeam2Id != null;
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

  /// Check if the new Home Team name is not equal to the Away Team name, to
  /// avoid the same team playing against itself
  String validateInsertedHomeTeam(String teamName) {
    if(isAwayTeamInserted() && tempMatch.getAwaySeasonTeamName() == teamName) {
      return MatchDetailLayout.INSERTED_TEAM_ERROR_ALREADY_INSERTED;
    }
    return null; //Everything ok
  }

  /// Check if the new Away Team name is not equal to the Home Team name, to
  /// avoid the same team playing against itself
  String validateInsertedAwayTeam(String teamName) {
    if(isHomeTeamInserted() && tempMatch.getHomeSeasonTeamName() == teamName) {
      return MatchDetailLayout.INSERTED_TEAM_ERROR_ALREADY_INSERTED;
    }
    return null; //Everything ok
  }

  Future<void> updateHomeTeamOnInsert(BuildContext context, bool isEditEnabled, Match match) async {
    if(isEditEnabled) {
      SeasonTeam seasonTeam1;
      String oldTeam1Id = match.getHomeSeasonTeamId();
      bool isTeamPopulated = isHomeTeamPopulated();
      if(isTeamPopulated) {
        seasonTeam1 = await updateTeamDialog(context, match.getHomeSeasonTeamName(), validateInsertedHomeTeam);
      } else {
        seasonTeam1 = await updateTeamOnInsert(context, match.getHomeSeasonTeamName(), validateInsertedHomeTeam);
      }
      if(seasonTeam1 != null) {
        if(isTeamPopulated) {
          removeTeamPlayersFromMatch(match, oldTeam1Id);
        }
        setState(() {
          match.setSeasonTeam1(seasonTeam1);
        });
      }
    }
  }

  Future<void> updateAwayTeamOnInsert(BuildContext context, bool isEditEnabled, Match match) async {
    if(isEditEnabled) {
      SeasonTeam seasonTeam2;
      String oldTeam2Id = match.getAwaySeasonTeamId();
      bool isTeamPopulated = isAwayTeamPopulated();
      if(isTeamPopulated) {
        seasonTeam2 = await updateTeamDialog(context, match.getAwaySeasonTeamName(), validateInsertedAwayTeam);
      } else {
        seasonTeam2 = await updateTeamOnInsert(context, match.getAwaySeasonTeamName(), validateInsertedAwayTeam);
      }
      if(seasonTeam2 != null) {
        if(isTeamPopulated) {
          removeTeamPlayersFromMatch(match, oldTeam2Id);
        }
        setState(() {
          match.setSeasonTeam2(seasonTeam2);
        });
      }
    }
  }

  Future<SeasonTeam> updateTeamDialog(BuildContext context, String teamName, String Function(String) validateInsertedTeam) async {
    SeasonTeam seasonTeam;
    final dialog = ChangeTeamDialog(
      onConfirm: () async {
        print("onConfirm");
        seasonTeam = await updateTeamOnInsert(context, teamName, validateInsertedTeam);
        Navigator.of(context).pop();
      },
      onCancel: () => Navigator.of(context).pop(),
    );
    await dialog.showChangeTeamDialog(context);
    return seasonTeam;
  }

  Future<SeasonTeam> updateTeamOnInsert(BuildContext context, String teamName, String Function(String) validateInsertedTeam) async {
    SeasonTeam seasonTeam = await _showInsertTeamDialog(context, teamName, validateInsertedTeam);
    if(seasonTeam != null) {
      widget.onTeamInserted(seasonTeam.id);
    }
    return seasonTeam;
  }

  /// Replace team players with an empty player
  void removeTeamPlayersFromMatch(Match match, String seasonTeamId) {
    List<MatchPlayerData> newPlayerDataList = List();
    match.playersData.forEach((p) {
      if(p.seasonTeamId == seasonTeamId) {
        p = MatchPlayerData.empty(seasonTeamId, isRegular: p.isRegular);
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
    return Container(
      margin: const EdgeInsets.only(top: 0, bottom: 0),
      child: Stack(
        children: [
          matchInfoBackground(),
          matchInfoForeground(context, matchInfo, isEditEnabled),
        ],
      ),
    );
  }

  Widget matchInfoBackground() {
    return Container(
      child: ClipRect(
        child: Image.asset(
          ImageAssets.IMAGE_MATCH_DETAIL_BACKGROUND,
          width: widget.maxWidth,
          height: MatchDetailLayout.MATCH_INFO_HEIGHT,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget matchInfoForeground(BuildContext context, Match matchInfo, bool isEditEnabled) {
    double matchInfoHeight = MatchDetailLayout.MATCH_INFO_HEIGHT;
    return Container(
      width: widget.maxWidth,
      height: matchInfoHeight,
      child: Column(
        children: [
          matchInfoTopRow(context, matchInfo, isEditEnabled, matchInfoHeight),
          matchInfoBottomRow(context, matchInfo, isEditEnabled, matchInfoHeight),
        ],
      ),
    );
  }

  Widget matchInfoTopRow(BuildContext context, Match matchInfo, bool isEditEnabled, double matchInfoHeight) {
    double height = 0.75 * matchInfoHeight;
    double topMargin = 0.24 * matchInfoHeight;
    TextStyle textStyle = DetailViewTitleTextStyle();
    double avatarSize = MatchDetailLayout.MATCH_INFO_LOGO_SIZE;
    return Container(
      height: height,
      padding: EdgeInsets.only(top: topMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          homeTeamColumn(context, matchInfo, isEditEnabled, textStyle, avatarSize),
          matchResult(isEditEnabled, textStyle),
          awayTeamColumn(context, matchInfo, isEditEnabled, textStyle, avatarSize),
        ],
      ),
    );
  }

  Widget matchInfoBottomRow(BuildContext context, Match matchInfo, bool isEditEnabled, double matchInfoHeight) {
    double height = 0.25 * matchInfoHeight;
    TextStyle textStyle = DetailViewSubtitleTextStyle();
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leagueMatchWidget(isEditEnabled, textStyle),
          matchDateWidget(context, matchInfo, isEditEnabled, textStyle),
        ],
      ),
    );
  }

  Widget homeTeamColumn(BuildContext context, Match matchInfo, bool isEditEnabled, TextStyle textStyle, double avatarSize) {
    final widgets = [
      teamImageWidget(TeamAssets.getRandomImage(), avatarSize),
      CustomRichText(
        onTap: () => updateHomeTeamOnInsert(context, isEditEnabled, matchInfo),
        enabled: isEditEnabled,
        text: matchInfo.getHomeSeasonTeamName(),
        textAlign: TextAlign.center,
        fontColor: textStyle.color,
        fontWeight: textStyle.fontWeight,
        fontSize: textStyle.fontSize,
      ),
    ];
    return teamColumn(widgets);
  }

  Widget awayTeamColumn(BuildContext context, Match matchInfo, bool isEditEnabled, TextStyle textStyle, double avatarSize) {
    final widgets = [
      teamImageWidget(TeamAssets.getRandomImage(), avatarSize),
      CustomRichText(
        onTap: () => updateAwayTeamOnInsert(context, isEditEnabled, matchInfo),
        enabled: isEditEnabled,
        text: matchInfo.getAwaySeasonTeamName(),
        textAlign: TextAlign.center,
        fontColor: textStyle.color,
        fontWeight: textStyle.fontWeight,
        fontSize: textStyle.fontSize,
      ),
    ];
    return teamColumn(widgets);
  }

  Widget teamImageWidget(String imageAsset, double avatarSize) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(100),
        borderRadius: BorderRadius.circular(48),
      ),
      width: avatarSize,
      height: avatarSize,
      child: SvgImage(
        imageAsset: imageAsset,
        width: avatarSize,
        height: avatarSize,
      ),
    );
  }

  Widget teamColumn(List<Widget> children) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget matchResult(bool isEditEnabled, TextStyle textStyle) {
    return Expanded(
      child: Container(
        child: resultWidget(resultTextEditingController1, resultTextEditingController2, textStyle.color, 32, textStyle.fontWeight, isEditEnabled),
      ),
    );
  }

  Widget leagueMatchWidget(bool isEditEnabled, TextStyle textStyle) {
    return Expanded(
      flex: 1,
      child: Container(
        // margin: EdgeInsets.only(left: 12, top: 10, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Giornata',
              textAlign: TextAlign.start,
              style: TextStyle(
                color: textStyle.color,
                fontWeight: textStyle.fontWeight,
                fontSize: textStyle.fontSize,
              ),
            ),
            // SizedBox(width: 2,),
            CustomTextField(
              enabled: isEditEnabled,
              width: 50,
              controller: leagueMatchTextEditingController,
              textAlign: TextAlign.center,
              textAlignVertical: TextAlignVertical.top,
              maxLines: 1,
              textInputType: TextInputType.number,
              textColor: textStyle.color,
              textFontSize: textStyle.fontSize,
              textFontWeight: textStyle.fontWeight,
              bottomBorderPadding: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget matchDateWidget(BuildContext context, Match matchInfo, bool isEditEnabled, TextStyle textStyle) {
    return Expanded(
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
          child: DateWidget(
            dateTime: matchInfo.matchDate,
            textStyle: textStyle,
            mainAxisAlignment: MainAxisAlignment.end,
          ),
        ),
      ),
    );
  }

  Widget matchCharacteristics(BuildContext context, bool isEditEnabled) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
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
      ),
      child: Column(
        children: [
          divider(),
          lineUpText("Note Partita"),
          textBox(isEditEnabled),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(horizontal: BorderSide(color: blueAgonisticaColor.withAlpha(128), width: 0.5)),
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
    balanceTeamPlayers(homeRegularPlayers, numRegularPlayers, tempMatch.getHomeSeasonTeamId(), true);
    balanceTeamPlayers(awayRegularPlayers, numRegularPlayers, tempMatch.getAwaySeasonTeamId(), true);

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
    balanceTeamPlayers(homeReservePlayers, numReservePlayers, tempMatch.getHomeSeasonTeamId(), false);
    balanceTeamPlayers(awayReservePlayers, numReservePlayers, tempMatch.getAwaySeasonTeamId(), false);

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
                String seasonTeamId = isHomePlayer ? tempMatch.getHomeSeasonTeamId() : tempMatch.getAwaySeasonTeamId();
                List<SeasonPlayer> seasonPlayers = widget.onPlayersSuggestionCallback(namePattern, surnamePattern, seasonTeamId);
                // Remove players already in the lineup
                List<String> lineupPlayersIds = tempMatch.playersData.map((p) => p.seasonPlayerId).toList();
                seasonPlayers.removeWhere((p) => lineupPlayersIds.contains(p.id));
                return seasonPlayers;
              },
              onSaveCallback: (matchPlayerData, isHomePlayer) {
                setState(() {
                  _replacePlayerUsingId(tempMatch.playersData, matchPlayerData);
                });
              },
              onViewPlayerCardCallback: (matchPlayerData) => widget.onViewPlayerCardCallback(matchPlayerData.seasonPlayerId),
              onDeleteCallback: (matchPlayerData, isHomePlayer) {
                setState(() {
                  tempMatch.playersData.remove(matchPlayerData);
                });
              },
              onInsertNotesCallback: (matchPlayerData) =>  widget.onInsertNotesCallback(tempMatch, matchPlayerData),
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
    MatchPlayerData newHomePlayer = _addRegularPlayer(tempMatch.getHomeSeasonTeamId());
    MatchPlayerData newAwayPlayer = _addRegularPlayer(tempMatch.getAwaySeasonTeamId());
    _addNewRow(newHomePlayer, newAwayPlayer);
  }

  void _addNewRowWithReservePlayers() {
    MatchPlayerData newHomePlayer = _addReservePlayer(tempMatch.getHomeSeasonTeamId());
    MatchPlayerData newAwayPlayer = _addReservePlayer(tempMatch.getAwaySeasonTeamId());
    _addNewRow(newHomePlayer, newAwayPlayer);
  }

  MatchPlayerData _addRegularPlayer(String seasonTeamId) {
    return MatchPlayerData.empty(seasonTeamId, isRegular: true);
  }

  MatchPlayerData _addReservePlayer(String seasonTeamId) {
    return MatchPlayerData.empty(seasonTeamId, isRegular: false);
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

  Future<SeasonTeam> _showInsertTeamDialog(BuildContext context, String tempTeamName, String Function(String) validateInsertedTeam) async {
    SeasonTeam tempSeasonTeam;
    InsertTeamDialog insertTeamDialog = InsertTeamDialog(
        initialValue: tempTeamName,
        maxHeight: MediaQuery.of(context).size.height,
        seasonId: tempMatch.seasonId,
        suggestionCallback: (pattern) {
          return widget.onTeamSuggestionCallback(pattern);
        },
        isInsertedTeamValid: validateInsertedTeam,
        onSubmit: (finalTeamValue) {
          Navigator.of(context).pop();
          if(finalTeamValue != null) {
            tempSeasonTeam = finalTeamValue;
          }
        }
    );
    await insertTeamDialog.showInsertTeamDialog(context);
    return tempSeasonTeam;
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