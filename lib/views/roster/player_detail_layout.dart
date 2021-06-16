// @dart=2.9

import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/views/roster/category_label.dart';
import 'package:agonistica/views/roster/name_label.dart';
import 'package:agonistica/views/roster/stat_row.dart';
import 'package:agonistica/views/roster/team_label.dart';
import 'package:agonistica/widgets/base/base_widget.dart';
import 'package:agonistica/widgets/common/date_widget.dart';
import 'package:agonistica/widgets/images/svg_image.dart';
import 'package:agonistica/widgets/text/custom_text_field.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:agonistica/core/utils/my_snackbar.dart';
import 'package:agonistica/views/roster/stat_element.dart';
import 'package:agonistica/widgets/text_styles/detail_view_header_text_style.dart';
import 'package:agonistica/widgets/text_styles/detail_view_sub_header_text_style.dart';
import 'package:agonistica/widgets/text_styles/detail_view_subtitle_text_style.dart';
import 'package:agonistica/widgets/text_styles/detail_view_title_text_style.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PlayerDetailLayout extends StatefulWidget {

  static const int STAT_ROLE = 0;
  static const int STAT_FOOT = 1;
  static const int STAT_MATCHES = 2;
  static const int STAT_GOALS = 3;
  static const int STAT_YELLOW_CARDS = 4;
  static const int STAT_RED_CARDS = 5;

  static const double PLAYER_AVATAR_SIZE = 70;
  static const double ICON_SIZE = 20;

  final SeasonPlayer seasonPlayer;
  final bool isEditEnabled;
  final double maxWidth;
  final PlayerDetailController controller;
  final List<SeasonTeam> Function(String) onSuggestionTeamCallback;
  final Future<List<Category>> Function(SeasonTeam) teamCategoriesCallback;
//  final Function(Player) onSave;

  PlayerDetailLayout({
    @required this.seasonPlayer,
    @required this.isEditEnabled,
    @required this.controller,
    @required this.onSuggestionTeamCallback,
    @required this.teamCategoriesCallback,
//    @required this.onSave,
    this.maxWidth
  }) : assert(seasonPlayer != null);

  @override
  State<StatefulWidget> createState() => _PlayerDetailLayoutState(controller);

}

class _PlayerDetailLayoutState extends State<PlayerDetailLayout> {

  bool editEnabled;

  SeasonPlayer tempSeasonPlayer;

  TextEditingController nameTextController, surnameTextController,
      heightTextController, weightTextController;

  String roleText, footText;
  TextEditingController matchesTextController, goalsTextController,
      yellowTextController, redTextController;

  TextEditingController morfologiaTextController, sommatoTipoTextController;

  TextEditingController attitude1TextController, attitude2TextController,
      attitude3TextController;

  _PlayerDetailLayoutState(PlayerDetailController controller) {
    controller.savePlayerStatus = () => savePlayerState();
  }

  @override
  void initState() {
    super.initState();
    // if it's a new player enable already edit mode, otherwise start in view mode
    editEnabled = widget.isEditEnabled;

    nameTextController = TextEditingController();
    surnameTextController = TextEditingController();
    heightTextController = TextEditingController();
    weightTextController = TextEditingController();

    matchesTextController = TextEditingController();
    goalsTextController = TextEditingController();
    yellowTextController = TextEditingController();
    redTextController = TextEditingController();

    morfologiaTextController = TextEditingController();
    sommatoTipoTextController = TextEditingController();

    attitude1TextController = TextEditingController();
    attitude2TextController = TextEditingController();
    attitude3TextController = TextEditingController();

    updatePlayerObject();
    reset();

  }

  @override
  void didUpdateWidget(covariant PlayerDetailLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    editEnabled = widget.isEditEnabled;
    updatePlayerObject();
    if(oldWidget.isEditEnabled != widget.isEditEnabled)
      reset();
  }

  void reset() {
    nameTextController.text = tempSeasonPlayer.getPlayerName();
    surnameTextController.text = tempSeasonPlayer.getPlayerSurname();
    heightTextController.text = tempSeasonPlayer.height.toString();
    weightTextController.text = tempSeasonPlayer.weight.toString();

    roleText = SeasonPlayer.positionToString(tempSeasonPlayer.position);
    footText = tempSeasonPlayer.isRightHanded() ? "Destro" : "Sinistro";
    matchesTextController.text = tempSeasonPlayer.matches.toString();
    goalsTextController.text = tempSeasonPlayer.goals.toString();
    yellowTextController.text = tempSeasonPlayer.yellowCards.toString();
    redTextController.text = tempSeasonPlayer.redCards.toString();

    morfologiaTextController.text = tempSeasonPlayer.morfologia;
    sommatoTipoTextController.text = tempSeasonPlayer.sommatoTipo;

    attitude1TextController.text = tempSeasonPlayer.attitudine1;
    attitude2TextController.text = tempSeasonPlayer.attitudine2;
    attitude3TextController.text = tempSeasonPlayer.attitudine3;
  }

  void updatePlayerObject() {
    tempSeasonPlayer = widget.seasonPlayer;
  }

  bool savePlayerState() {
    String errorMessage = validateTextFields();
    bool isError = errorMessage != null;
    if(isError) {
      final _baseScaffoldService = locator<BaseScaffoldService>();
      MySnackBar.showSnackBar(_baseScaffoldService.scaffoldContext, errorMessage);
      return false;
    }

    tempSeasonPlayer.setPlayerName(nameTextController.text);
    tempSeasonPlayer.setPlayerSurname(surnameTextController.text);
    tempSeasonPlayer.height = int.tryParse(heightTextController.text);
    tempSeasonPlayer.weight = int.tryParse(weightTextController.text);

    tempSeasonPlayer.position = SeasonPlayer.stringToPosition(roleText);
    tempSeasonPlayer.setIsRightHanded(footText == "Destro" ? true : false);
    tempSeasonPlayer.matches = int.tryParse(matchesTextController.text);
    tempSeasonPlayer.goals = int.tryParse(goalsTextController.text);
    tempSeasonPlayer.yellowCards = int.tryParse(yellowTextController.text);
    tempSeasonPlayer.redCards = int.tryParse(redTextController.text);

    tempSeasonPlayer.morfologia = morfologiaTextController.text;
    tempSeasonPlayer.sommatoTipo = sommatoTipoTextController.text;
    tempSeasonPlayer.attitudine1 = attitude1TextController.text;
    tempSeasonPlayer.attitudine2 = attitude2TextController.text;
    tempSeasonPlayer.attitudine3 = attitude3TextController.text;

    return true;
  }

  /// Validate Player's name, surname and integers values. Position and
  /// isRightHanded are already restricted values. The other fields are all text
  String validateTextFields() {
    String errorMessage = InputValidation.validatePlayerName(nameTextController.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validatePlayerSurname(surnameTextController.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateTeamName(tempSeasonPlayer.getSeasonTeam().getTeamName());
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateInteger(heightTextController.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateInteger(weightTextController.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateInteger(matchesTextController.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateInteger(goalsTextController.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateInteger(yellowTextController.text);
    if(errorMessage != null) return errorMessage;
    errorMessage = InputValidation.validateInteger(redTextController.text);
    if(errorMessage != null) return errorMessage;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 0),
          width: widget.maxWidth,
          child: Column(
            children: [
              playerInfo(context, editEnabled, tempSeasonPlayer, nameTextController, surnameTextController, heightTextController, weightTextController),
              playerCharacteristics(context, tempSeasonPlayer, editEnabled, roleText, footText, matchesTextController, goalsTextController, yellowTextController, redTextController,
              morfologiaTextController, sommatoTipoTextController, attitude1TextController, attitude2TextController, attitude3TextController),
            ],
          ),
        ),
      ),
    );
  }

  Widget playerInfo(BuildContext context, bool isEditEnabled, SeasonPlayer playerInfo, TextEditingController nameTextController,
      TextEditingController surnameTextController, TextEditingController heightTextController,
      TextEditingController weightTextController) {
    return Container(
      constraints: BoxConstraints(
        minHeight: 150,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Column(
        children: [
          playerInfoHeader(isEditEnabled, playerInfo, nameTextController, surnameTextController),
          playerInfoSubHeader(context, isEditEnabled, playerInfo, heightTextController, weightTextController),
        ]
      ),
    );
  }

  Widget playerInfoHeader(bool isEditEnabled, SeasonPlayer playerInfo, TextEditingController nameTextController,
      TextEditingController surnameTextController) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        playerAvatar(),
        playerInfoHeaderName(isEditEnabled, playerInfo, nameTextController, surnameTextController),
      ],
    );
  }

  Widget playerAvatar() {
    return Expanded(
      flex: 2,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle
        ),
        alignment: Alignment.center,
        child: SvgImage(
          imageAsset: IconAssets.ICON_FOOTBALL_PLAYER,
          width: PlayerDetailLayout.PLAYER_AVATAR_SIZE,
          height: PlayerDetailLayout.PLAYER_AVATAR_SIZE,
        ),
      ),
    );
  }

  Widget playerInfoHeaderName(bool isEditEnabled, SeasonPlayer playerInfo, TextEditingController nameTextController,
      TextEditingController surnameTextController) {
    TextStyle titleStyle = DetailViewTitleTextStyle();
    TextStyle teamStyle = DetailViewHeaderTextStyle();
    TextStyle categoryStyle = DetailViewSubHeaderTextStyle();
    return Expanded(
      flex: 4,
      child: Container(
        margin: EdgeInsets.only(left: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NameLabel(
              nameTextController: nameTextController,
              surnameTextController: surnameTextController,
              isEditEnabled: isEditEnabled,
              fontColor: titleStyle.color,
              fontSize: titleStyle.fontSize,
              fontWeight: titleStyle.fontWeight,
            ),
            SizedBox(height: 10,),
            TeamLabel(
                teamName: playerInfo.getSeasonTeam().getTeamName(),
                seasonId: playerInfo.getSeasonTeam().seasonId,
                isEditEnabled: isEditEnabled,
                onSuggestionTeamCallback: (pattern) => widget.onSuggestionTeamCallback(pattern),
                onTeamChange: (seasonTeam) {
                  setState(() {
                    playerInfo.setSeasonTeam(seasonTeam);
                  });
                },
                fontColor: teamStyle.color,
                fontWeight: teamStyle.fontWeight,
                fontSize: teamStyle.fontSize
            ),
            SizedBox(height: 10,),
            CategoryLabel(
              categoryName: playerInfo.getCategory().name,
              isEditEnabled: isEditEnabled,
              teamCategoriesCallback: () => widget.teamCategoriesCallback(playerInfo.getSeasonTeam()),
              onCategoryChange: (category) {
                setState(() {
                  playerInfo.setCategory(category);
                });
              },
              fontColor: categoryStyle.color,
              fontSize: categoryStyle.fontSize,
              fontWeight: categoryStyle.fontWeight,
            ),
          ],
        ),
      ),
    );
  }

  Widget playerInfoSubHeader(BuildContext context, bool isEditEnabled, SeasonPlayer playerInfo, TextEditingController heightTextController,
      TextEditingController weightTextController) {
    final double textFieldWidth = 30;
    TextStyle textStyle = DetailViewSubtitleTextStyle();
    return Container(
      margin: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          playerInfoHeight(isEditEnabled, playerInfo, heightTextController, textFieldWidth, textStyle),
          playerInfoWeight(isEditEnabled, playerInfo, weightTextController, textFieldWidth, textStyle),
          playerInfoBirthday(context, isEditEnabled, playerInfo, textStyle),
        ],
      ),
    );
  }

  Widget playerInfoHeight(bool isEditEnabled, SeasonPlayer playerInfo, TextEditingController heightTextController, double textFieldWidth, TextStyle textStyle) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgImage(
            imageAsset: IconAssets.ICON_HEIGHT,
            width: PlayerDetailLayout.ICON_SIZE,
            height: PlayerDetailLayout.ICON_SIZE,
            color: Colors.white,
          ),
          // SizedBox(width: 5,),
          CustomTextField(
            width: textFieldWidth,
            enabled: isEditEnabled,
            controller: heightTextController,
            textAlign: TextAlign.end,
            maxLines: 1,
            textInputType: TextInputType.number,
            textColor: textStyle.color,
            textFontSize: textStyle.fontSize,
            textFontWeight: textStyle.fontWeight,
          ),
          SizedBox(width: 5,),
          Text(
            "cm",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: textStyle.color,
              fontSize: textStyle.fontSize,
              fontWeight: textStyle.fontWeight,
            ),
          )
        ],
      ),
    );
  }

  Widget playerInfoWeight(bool isEditEnabled, SeasonPlayer playerInfo, TextEditingController weightTextController, double textFieldWidth, TextStyle textStyle) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.weight,
            color: Colors.white,
            size: PlayerDetailLayout.ICON_SIZE,
          ),
          // SizedBox(width: 5,),
          CustomTextField(
            width: textFieldWidth,
            enabled: isEditEnabled,
            controller: weightTextController,
            textAlign: TextAlign.end,
            maxLines: 1,
            textInputType: TextInputType.number,
            textColor: textStyle.color,
            textFontSize: textStyle.fontSize,
            textFontWeight: textStyle.fontWeight,
          ),
          SizedBox(width: 5,),
          Text(
            "kg",
            textAlign: TextAlign.end,
            style: TextStyle(
              color: textStyle.color,
              fontSize: textStyle.fontSize,
              fontWeight: textStyle.fontWeight,
            ),
          )
        ],
      ),
    );
  }

  Widget playerInfoBirthday(BuildContext context, bool isEditEnabled, SeasonPlayer playerInfo, TextStyle textStyle) {
    return Container(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () async {
          if (isEditEnabled) {
            DateTime curDate = DateTime.now();
            await showDatePicker(
                context: context,
                initialDate: playerInfo.getPlayerBirthday(),
                firstDate: DateTime.utc(
                    curDate.year - 50),
                lastDate: DateTime.utc(
                    curDate.year + 1),
                initialDatePickerMode: DatePickerMode
                    .day,
                helpText: "Seleziona la data di nascita"
            ).then((date) {
              if (date != null)
                setState(() {
                  playerInfo.setPlayerBirthday(date);
                });
            });
          }
        },
        child: DateWidget(
          dateTime: playerInfo.getPlayerBirthday(),
          textStyle: textStyle,
          iconSize: PlayerDetailLayout.ICON_SIZE,
        ),
      ),
    );
  }

  Widget playerCharacteristics(BuildContext context, SeasonPlayer playerInfo, bool isEditEnabled, String roleText, String footText,
      TextEditingController matchesTextController, TextEditingController goalsTextController,
    TextEditingController yellowTextController, TextEditingController redTextController, TextEditingController morfologiaTextController,
      TextEditingController sommatoTipoTextController, TextEditingController attitude1TextController, TextEditingController attitude2TextController,
      TextEditingController attitude3TextController) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: firstRowStatElements(isEditEnabled, roleText, footText, matchesTextController),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: secondRowStatElements(isEditEnabled, goalsTextController, yellowTextController, redTextController),
          ),
          playerCharacteristicsBox(playerInfo, isEditEnabled),
          playerConditionalCapacitiesBox(playerInfo, isEditEnabled),
          playerMorphologyBox(isEditEnabled, morfologiaTextController, sommatoTipoTextController),
          playerAttitudesBox(isEditEnabled, attitude1TextController, attitude2TextController, attitude3TextController),
        ],
      ),
    );
  }

  List<Widget> firstRowStatElements(bool isEditEnabled, String roleText, String footText,
      TextEditingController matchesTextController) {
    return [
      StatElement(
        icon: PlayerDetailLayout.STAT_ROLE,
        elementName: "Ruolo",
        isEditEnabled: isEditEnabled,
        isFreeText: false,
        elementText: roleText,
        onElementChange: (value) => this.roleText = value, //use this variable otherwise new value isn't saved
      ),
      StatElement(
        icon: PlayerDetailLayout.STAT_FOOT,
        elementName: "Piede",
        isEditEnabled: isEditEnabled,
        isFreeText: false,
        elementText: footText,
        onElementChange: (value) => this.footText = value,
      ),
      StatElement(
        icon: PlayerDetailLayout.STAT_MATCHES,
        elementName: "Presenze",
        isEditEnabled: isEditEnabled,
        isFreeText: true,
        onElementChange: null,
        elementController: matchesTextController,
      ),
    ];
  }

  List<Widget> secondRowStatElements(bool isEditEnabled, TextEditingController goalsTextController,
      TextEditingController yellowTextController, TextEditingController redTextController) {
    return [
      StatElement(
        icon: PlayerDetailLayout.STAT_GOALS,
        elementName: "Gol",
        isEditEnabled: isEditEnabled,
        isFreeText: true,
        onElementChange: null,
        elementController: goalsTextController,
      ),
      StatElement(
        icon: PlayerDetailLayout.STAT_YELLOW_CARDS,
        elementName: "Gialli",
        isEditEnabled: isEditEnabled,
        isFreeText: true,
        onElementChange: null,
        elementController: yellowTextController,
      ),
      StatElement(
        icon: PlayerDetailLayout.STAT_RED_CARDS,
        elementName: "Rossi",
        isEditEnabled: isEditEnabled,
        isFreeText: true,
        onElementChange: null,
        elementController: redTextController,
      ),
    ];
  }

  Widget playerCharacteristicsBox(SeasonPlayer playerInfo, bool isEditEnabled) {

    List<int> characteristics = [playerInfo.tecnica, playerInfo.agonistica, playerInfo.fisica, playerInfo.tattica, playerInfo.capMotorie];
    int sum = characteristics.reduce((a, b) => a + b);
    int meanCharacteristics = (sum / characteristics.length).round();


    return BaseWidget(
      builder: (context, sizingInformation, parentSizingInformation) {

        double width = 0.9 * sizingInformation.localWidgetSize.width;

        double circlesBarWidth = 0.6 * width;

        return Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: blueAgonisticaColor, width: 1, style: BorderStyle.solid)
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10),
            width: width,
            child: Column(
              children: [
                statTitleAndSummary("Caratteristiche", meanCharacteristics),
                StatRow(
                  statName: "Tecnica",
                  value: playerInfo.tecnica,
                  isEditEnabled: isEditEnabled,
                  onChange: (newValue) => playerInfo.tecnica = newValue,
                  width: circlesBarWidth
                ),
                StatRow(
                  statName: "Agonistica",
                  value: playerInfo.agonistica,
                  isEditEnabled: isEditEnabled,
                  onChange: (newValue) => playerInfo.agonistica = newValue,
                  width: circlesBarWidth
                ),
                StatRow(
                  statName: "Fisica",
                  value: playerInfo.fisica,
                  isEditEnabled: isEditEnabled,
                  onChange: (newValue) => playerInfo.fisica = newValue,
                  width: circlesBarWidth
                ),
                StatRow(
                  statName: "Tattica",
                  value: playerInfo.tattica,
                  isEditEnabled: isEditEnabled,
                  onChange: (newValue) => playerInfo.tattica = newValue,
                  width: circlesBarWidth
                ),
                StatRow(
                  statName: "Cap. Motorie",
                  value: playerInfo.capMotorie,
                  isEditEnabled: isEditEnabled,
                  onChange: (newValue) => playerInfo.capMotorie = newValue,
                  width: circlesBarWidth
                ),
                SizedBox(height: 5,) //use as margin bottom
              ],
            ),
          )
        );
      },
    );
  }

  Widget playerConditionalCapacitiesBox(SeasonPlayer playerInfo, bool isEditEnabled) {

    List<int> capacities = [playerInfo.velocita, playerInfo.rapidita, playerInfo.scatto, playerInfo.resistenza, playerInfo.corsa, playerInfo.progressione, playerInfo.cambioPasso, playerInfo.elevazione];
    int sum = capacities.reduce((a, b) => a + b);
    int meanCapacities = (sum / capacities.length).round();

    return BaseWidget(
      builder: (context, sizingInformation, parentSizingInformation) {

        double width = 0.9 * sizingInformation.localWidgetSize.width;

        double circlesBarWidth = 0.6 * width;

        return Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: blueAgonisticaColor, width: 1, style: BorderStyle.solid)
              ),
              margin: EdgeInsets.only(top: 10, bottom: 10),
              width: width,
              child: Column(
                children: [
                  statTitleAndSummary("Capacità condizionali", meanCapacities),
                  StatRow(
                    statName: "Velocità",
                    value: playerInfo.velocita,
                    isEditEnabled: isEditEnabled,
                    onChange: (newValue) => playerInfo.velocita = newValue,
                    width: circlesBarWidth
                  ),
                  StatRow(
                      statName: "Rapidità",
                      value: playerInfo.rapidita,
                      isEditEnabled: isEditEnabled,
                      onChange: (newValue) => playerInfo.rapidita = newValue,
                      width: circlesBarWidth
                  ),
                  StatRow(
                      statName: "Scatto",
                      value: playerInfo.scatto,
                      isEditEnabled: isEditEnabled,
                      onChange: (newValue) => playerInfo.scatto = newValue,
                      width: circlesBarWidth
                  ),
                  StatRow(
                      statName: "Resistenza",
                      value: playerInfo.resistenza,
                      isEditEnabled: isEditEnabled,
                      onChange: (newValue) => playerInfo.resistenza = newValue,
                      width: circlesBarWidth
                  ),
                  StatRow(
                      statName: "Corsa",
                      value: playerInfo.corsa,
                      isEditEnabled: isEditEnabled,
                      onChange: (newValue) => playerInfo.corsa = newValue,
                      width: circlesBarWidth
                  ),
                  StatRow(
                      statName: "Progressione",
                      value: playerInfo.progressione,
                      isEditEnabled: isEditEnabled,
                      onChange: (newValue) => playerInfo.progressione = newValue,
                      width: circlesBarWidth
                  ),
                  StatRow(
                      statName: "Cambio passo",
                      value: playerInfo.cambioPasso,
                      isEditEnabled: isEditEnabled,
                      onChange: (newValue) => playerInfo.cambioPasso = newValue,
                      width: circlesBarWidth
                  ),
                  StatRow(
                      statName: "Elevazione",
                      value: playerInfo.elevazione,
                      isEditEnabled: isEditEnabled,
                      onChange: (newValue) => playerInfo.elevazione = newValue,
                      width: circlesBarWidth
                  ),
                  SizedBox(height: 5,) //use as margin bottom
                ],
              ),
            )
        );
      },
    );
  }

  Widget statTitleAndSummary(String title, int meanValue) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: blueAgonisticaColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          summaryWidget(meanValue, SeasonPlayer.MAX_VALUE)
        ],
      ),
    );
  }

  Widget summaryWidget(int value, int maxValue, {double size}) {

    bool isTrendingUp = value > maxValue / 2;

    Widget trendingIcon = Icon(
      isTrendingUp ? Icons.trending_up : Icons.trending_down,
      size: size ?? 20,
      color: blueAgonisticaColor,
    );

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: blueAgonisticaColor),
      ),
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          trendingIcon,
          SizedBox(width: 3,),
          Text(
            "$value/$maxValue",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: blueAgonisticaColor,
              fontWeight: FontWeight.normal,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget playerMorphologyBox(bool isEditEnabled, TextEditingController morfologiaTextController,
      TextEditingController sommatoTipoTextController) {

    return BaseWidget(
      builder: (context, sizingInformation, parentSizingInformation) {

        double width = 0.9 * sizingInformation.localWidgetSize.width;

        double fieldWidth = 0.8 * width;

        return Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: blueAgonisticaColor)
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10),
            width: width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Morfologia",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: blueAgonisticaColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                    ),
                  ),
                ),
                CustomTextField(
                  width: fieldWidth,
                  enabled: isEditEnabled,
                  textAlign: TextAlign.center,
                  controller: morfologiaTextController,
                  textColor: blueAgonisticaColor,
                  textFontSize: 16,
                  textFontWeight: FontWeight.normal,
                  hint: "Specifica morfologia",
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Sommato Tipo",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: blueAgonisticaColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                CustomTextField(
                  width: fieldWidth,
                  enabled: isEditEnabled,
                  textAlign: TextAlign.center,
                  controller: sommatoTipoTextController,
                  textColor: blueAgonisticaColor,
                  textFontSize: 16,
                  textFontWeight: FontWeight.normal,
                  hint: "Specifica sommato tipo",
                ),
                SizedBox(height: 10,), //use as bottom margin
              ],
            ),
          ),
        );

      },
    );
  }

  Widget playerAttitudesBox(bool isEditEnabled, TextEditingController attitude1TextController,
      TextEditingController attitude2TextController, TextEditingController attitude3TextController) {

    return BaseWidget(
      builder: (context, sizingInformation, parentSizingInformation) {

        double width = 0.9 * sizingInformation.localWidgetSize.width;

        double fieldWidth = 0.8 * width;

        return Align(
          alignment: Alignment.center,
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: blueAgonisticaColor)
            ),
            margin: EdgeInsets.only(top: 10, bottom: 10),
            width: width,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Attitudine 1",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: blueAgonisticaColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                CustomTextField(
                  width: fieldWidth,
                  enabled: isEditEnabled,
                  textAlign: TextAlign.center,
                  controller: attitude1TextController,
                  textColor: blueAgonisticaColor,
                  textFontSize: 16,
                  textFontWeight: FontWeight.normal,
                  hint: "Specifica la prima attitudine",
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Attitudine 2",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: blueAgonisticaColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                CustomTextField(
                  width: fieldWidth,
                  enabled: isEditEnabled,
                  textAlign: TextAlign.center,
                  controller: attitude2TextController,
                  textColor: blueAgonisticaColor,
                  textFontSize: 16,
                  textFontWeight: FontWeight.normal,
                  hint: "Specifica la seconda attitudine",
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Attitudine 3",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: blueAgonisticaColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18
                    ),
                  ),
                ),
                CustomTextField(
                  width: fieldWidth,
                  enabled: isEditEnabled,
                  textAlign: TextAlign.center,
                  controller: attitude3TextController,
                  textColor: blueAgonisticaColor,
                  textFontSize: 16,
                  textFontWeight: FontWeight.normal,
                  hint: "Specifica la terza attitudine",
                ),
                SizedBox(height: 10,), //use as bottom margin
              ],
            ),
          ),
        );

      },
    );

  }

}

class PlayerDetailController {

  bool Function() savePlayerStatus;

}