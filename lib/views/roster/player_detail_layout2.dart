import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/custom_rich_text.dart';
import 'package:agonistica/core/shared/custom_text_field.dart';
import 'package:agonistica/core/shared/edit_detail_button.dart';
import 'package:agonistica/core/shared/insert_team_dialog.dart';
import 'package:agonistica/core/shared/select_category_dialog.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils.dart';
import 'package:agonistica/views/roster/category_label.dart';
import 'package:agonistica/views/roster/date_label.dart';
import 'package:agonistica/views/roster/roster_view.dart';
import 'package:agonistica/views/roster/stat_element.dart';
import 'package:agonistica/views/roster/stat_row.dart';
import 'package:agonistica/views/roster/team_label.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayerDetailLayout2 extends StatelessWidget {

  static const int STAT_ROLE = 0;
  static const int STAT_FOOT = 1;
  static const int STAT_MATCHES = 2;
  static const int STAT_GOALS = 3;
  static const int STAT_YELLOW_CARDS = 4;
  static const int STAT_RED_CARDS = 5;

//  final bool isNewPlayer;
  final Player player;
  final bool isEditEnabled;
  final double maxWidth;
  final PlayerDetailController2 controller;
  final List<Team> Function(String) onSuggestionTeamCallback;
  final Future<List<Category>> Function(Team) teamCategoriesCallback;

  final TextEditingController nameTextController = TextEditingController();
  final surnameTextController = TextEditingController();
  final heightTextController = TextEditingController();
  final weightTextController = TextEditingController();

  final TextEditingController matchesTextController = TextEditingController();
  final goalsTextController = TextEditingController();
  final yellowTextController = TextEditingController();
  final redTextController = TextEditingController();

  final TextEditingController morfologiaTextController = TextEditingController();
  final sommatoTipoTextController = TextEditingController();

  final TextEditingController attitude1TextController = TextEditingController();
  final attitude2TextController = TextEditingController();
  final attitude3TextController = TextEditingController();

  // NOT WORKING -> ELEMENTS IN UI DON'T CHANGE

  PlayerDetailLayout2({this.player, this.isEditEnabled, this.controller, this.onSuggestionTeamCallback, this.teamCategoriesCallback, this.maxWidth}) {
    controller.savePlayerStatus = savePlayerState;
    print("constructor");
    nameTextController.text = player.name;
    surnameTextController.text = player.surname;
    heightTextController.text = player.height.toString();
    weightTextController.text = player.weight.toString();

    matchesTextController.text = player.matches.toString();
    goalsTextController.text = player.goals.toString();
    yellowTextController.text = player.yellowCards.toString();
    redTextController.text = player.redCards.toString();

    morfologiaTextController.text = player.morfologia;
    sommatoTipoTextController.text = player.sommatoTipo;

    attitude1TextController.text = player.attitudine1;
    attitude2TextController.text = player.attitudine2;
    attitude3TextController.text = player.attitudine3;
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        child: Container(
          width: maxWidth,
          child: Column(
            children: [
              playerInfo(context, isEditEnabled, player, nameTextController, surnameTextController, heightTextController, weightTextController),
              playerCharacteristics(context, player, isEditEnabled, matchesTextController, goalsTextController, yellowTextController, redTextController,
                  morfologiaTextController, sommatoTipoTextController, attitude1TextController, attitude2TextController, attitude3TextController),
            ],
          ),
        ),
      ),
    );
  }

  void savePlayerState() {
    print("savePlayerState called");
    //TODO Check if there are not textfields with errors

    player.name = nameTextController.text;
    player.surname = surnameTextController.text;
    player.height = int.tryParse(heightTextController.text);
    player.weight = int.tryParse(weightTextController.text);

    player.matches = int.tryParse(matchesTextController.text);
    player.goals = int.tryParse(goalsTextController.text);
    player.yellowCards = int.tryParse(yellowTextController.text);
    player.redCards = int.tryParse(redTextController.text);

    player.morfologia = morfologiaTextController.text;
    player.sommatoTipo = sommatoTipoTextController.text;
    player.attitudine1 = attitude1TextController.text;
    player.attitudine2 = attitude2TextController.text;
    player.attitudine3 = attitude3TextController.text;
  }

  Widget playerInfo(BuildContext context, bool isEditEnabled, Player playerInfo, TextEditingController nameTextController,
      TextEditingController surnameTextController, TextEditingController heightTextController,
      TextEditingController weightTextController) {

    final Color playerNameTextColor = blueAgonisticaColor;
    final double playerNameTextSize = 20;
    final FontWeight playerNameTextWeight = FontWeight.bold;

    final Color playerTeamTextColor = Colors.black;
    final double playerTeamTextSize = 18;
    final FontWeight playerTeamTextWeight = FontWeight.normal;

    final Color playerCategoryTextColor = Colors.black;
    final double playerCategoryTextSize = 16;
    final FontWeight playerCategoryTextWeight = FontWeight.normal;

    final Color playerHeightTextColor = Colors.black;
    final double playerHeightTextSize = 14;
    final FontWeight playerHeightTextWeight = FontWeight.normal;

    final double heightWidth = 40;

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          height: 90,
          margin: EdgeInsets.only(top: 20),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    child: SvgPicture.asset(
                      'assets/images/male.svg',
                      height: 50,
                      width: 50,
                      color: blueAgonisticaColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isEditEnabled ?
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextField(
                              enabled: isEditEnabled,
                              controller: nameTextController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              textColor: playerNameTextColor,
                              textFontSize: playerNameTextSize,
                              textFontWeight: playerNameTextWeight,
                            ),
                            SizedBox(width: 5,),
                            CustomTextField(
                              enabled: isEditEnabled,
                              controller: surnameTextController,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              textInputType: TextInputType.text,
                              textColor: playerNameTextColor,
                              textFontSize: playerNameTextSize,
                              textFontWeight: playerNameTextWeight,
                            ),
                          ],
                        )
                            : Text(
                          "${nameTextController.text} ${surnameTextController.text}",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: playerNameTextColor,
                            fontWeight: playerNameTextWeight,
                            fontSize: playerNameTextSize,
                          ),
                        ),
                        TeamLabel(
                          teamName: playerInfo.teamName,
                          isEditEnabled: isEditEnabled,
                          onSuggestionTeamCallback: onSuggestionTeamCallback,
                          onTeamChange: (team) => playerInfo.setTeam(team),
                          fontColor: playerTeamTextColor,
                          fontSize: playerTeamTextSize,
                          fontWeight: playerTeamTextWeight,
                        ),
                        CategoryLabel(
                          categoryName: playerInfo.categoryName,
                          isEditEnabled: isEditEnabled,
                          teamCategoriesCallback: () => teamCategoriesCallback(playerInfo.getTeam()),
                          onCategoryChange: (newCategory) => playerInfo.setCategory(newCategory),
                          fontColor: playerCategoryTextColor,
                          fontSize: playerCategoryTextSize,
                          fontWeight: playerCategoryTextWeight,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.centerRight,
                          child: DateLabel(
                            birthDay: playerInfo.birthDay,
                            isEditEnabled: isEditEnabled,
                            fontColor: playerHeightTextColor,
                            fontSize: playerHeightTextSize,
                            fontWeight: playerHeightTextWeight,
                            onDateChange: (dateTime) => playerInfo.birthDay = dateTime,
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextField(
                                width: heightWidth,
                                enabled: isEditEnabled,
                                controller: heightTextController,
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                textInputType: TextInputType.number,
                                textColor: playerHeightTextColor,
                                textFontSize: playerHeightTextSize,
                                textFontWeight: playerHeightTextWeight,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "cm",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: playerHeightTextColor,
                                  fontSize: playerHeightTextSize,
                                  fontWeight: playerHeightTextWeight,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CustomTextField(
                                width: heightWidth,
                                enabled: isEditEnabled,
                                controller: weightTextController,
                                textAlign: TextAlign.end,
                                maxLines: 1,
                                textInputType: TextInputType.number,
                                textColor: playerHeightTextColor,
                                textFontSize: playerHeightTextSize,
                                textFontWeight: playerHeightTextWeight,
                              ),
                              SizedBox(width: 5,),
                              Text(
                                "kg",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                  color: playerHeightTextColor,
                                  fontSize: playerHeightTextSize,
                                  fontWeight: playerHeightTextWeight,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget playerCharacteristics(BuildContext context, Player playerInfo, bool isEditEnabled,
      TextEditingController matchesTextController, TextEditingController goalsTextController,
      TextEditingController yellowTextController, TextEditingController redTextController, TextEditingController morfologiaTextController,
      TextEditingController sommatoTipoTextController, TextEditingController attitude1TextController, TextEditingController attitude2TextController,
      TextEditingController attitude3TextController) {

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              statElement(STAT_ROLE, "Ruolo", isEditEnabled, false, elementText: Player.positionToString(player.position), onElementSelect: (value) => player.position = value),
              statElement(STAT_FOOT, "Piede", isEditEnabled, false, elementText: player.isRightHanded ? "Destro" : "Sinistro", onElementSelect: (value) => player.isRightHanded = value == 0 ? true : false),
              statElement(STAT_MATCHES, "Presenze", isEditEnabled, true, elementController: matchesTextController),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              statElement(STAT_GOALS, "Gol", isEditEnabled, true, elementController: goalsTextController),
              statElement(STAT_YELLOW_CARDS, "Gialli", isEditEnabled, true, elementController: yellowTextController),
              statElement(STAT_RED_CARDS, "Rossi", isEditEnabled, true, elementController: redTextController),
            ],
          ),
          playerCharacteristicsBox(playerInfo, isEditEnabled),
          playerConditionalCapacitiesBox(playerInfo, isEditEnabled),
          playerMorphologyBox(isEditEnabled, morfologiaTextController, sommatoTipoTextController),
          playerAttitudesBox(isEditEnabled, attitude1TextController, attitude2TextController, attitude3TextController),
        ],
      ),
    );
  }

  Widget statElement(int icon, String elementName, bool isEditEnabled, bool isFreeText, {TextEditingController elementController, String elementText, Function(int) onElementSelect}) {
    return StatElement(
      icon: icon,
      elementName: elementName,
      isEditEnabled: isEditEnabled,
      isFreeText: isFreeText,
      onElementChange: onElementSelect,
      elementController: elementController,
      elementText: elementText,
    );
  }

  Widget playerCharacteristicsBox(Player playerInfo, bool isEditEnabled) {

    List<int> characteristics = [playerInfo.tecnica, playerInfo.agonistica, playerInfo.fisica, playerInfo.tattica, playerInfo.capMotorie];
    int sum = characteristics.reduce((a, b) => a + b);
    int meanCharacteristics = (sum / characteristics.length).round();


    return BaseWidget(
      builder: (context, sizingInformation) {

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
                  statRow("Tecnica", playerInfo.tecnica, isEditEnabled, (newValue) => playerInfo.tecnica = newValue, circlesBarWidth),
                  statRow("Agonistica", playerInfo.agonistica, isEditEnabled, (newValue) => playerInfo.agonistica = newValue, circlesBarWidth),
                  statRow("Fisica", playerInfo.fisica, isEditEnabled, (newValue) => playerInfo.fisica = newValue, circlesBarWidth),
                  statRow("Tattica", playerInfo.tattica, isEditEnabled, (newValue) => playerInfo.tattica = newValue, circlesBarWidth),
                  statRow("Cap. Motorie", playerInfo.capMotorie, isEditEnabled, (newValue) => playerInfo.capMotorie = newValue, circlesBarWidth),
                  SizedBox(height: 5,) //use as margin bottom
                ],
              ),
            )
        );
      },
    );
  }

  Widget playerConditionalCapacitiesBox(Player playerInfo, bool isEditEnabled) {

    List<int> capacities = [playerInfo.velocita, playerInfo.rapidita, playerInfo.scatto, playerInfo.resistenza, playerInfo.corsa, playerInfo.progressione, playerInfo.cambioPasso, playerInfo.elevazione];
    int sum = capacities.reduce((a, b) => a + b);
    int meanCapacities = (sum / capacities.length).round();

    return BaseWidget(
      builder: (context, sizingInformation) {

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
                  statRow("Velocità", playerInfo.velocita, isEditEnabled, (newValue) => playerInfo.velocita = newValue, circlesBarWidth),
                  statRow("Rapidità", playerInfo.rapidita, isEditEnabled, (newValue) => playerInfo.rapidita = newValue, circlesBarWidth),
                  statRow("Scatto", playerInfo.scatto, isEditEnabled, (newValue) => playerInfo.scatto = newValue, circlesBarWidth),
                  statRow("Resistenza", playerInfo.resistenza, isEditEnabled, (newValue) => playerInfo.resistenza = newValue, circlesBarWidth),
                  statRow("Corsa", playerInfo.corsa, isEditEnabled, (newValue) => playerInfo.corsa = newValue, circlesBarWidth),
                  statRow("Progressione", playerInfo.progressione, isEditEnabled, (newValue) => playerInfo.progressione = newValue, circlesBarWidth),
                  statRow("Cambio passo", playerInfo.cambioPasso, isEditEnabled, (newValue) => playerInfo.cambioPasso = newValue, circlesBarWidth),
                  statRow("Elevazione", playerInfo.elevazione, isEditEnabled, (newValue) => playerInfo.elevazione = newValue, circlesBarWidth),
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
          summaryWidget(meanValue, Player.MAX_VALUE)
        ],
      ),
    );
  }

  Widget statRow(String statName, int value, bool isEditEnabled, Function(int) onChange, double width) {
    if(value == null)
      value = 1;
    return StatRow(
      statName: statName,
      value: value,
      isEditEnabled: isEditEnabled,
      onChange: onChange,
      width: width,
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
      builder: (context, sizingInformation) {

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
      builder: (context, sizingInformation) {

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

class PlayerDetailController2 {

  void Function() savePlayerStatus;

}