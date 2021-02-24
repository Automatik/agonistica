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
import 'package:agonistica/views/roster/roster_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayerDetailLayout extends StatefulWidget {

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
  final PlayerDetailController controller;
  final List<Team> Function(String) onSuggestionTeamCallback;
  final Future<List<Category>> Function(Team) teamCategoriesCallback;
//  final Function(Player) onSave;

  PlayerDetailLayout({
    @required this.player,
    @required this.isEditEnabled,
    @required this.controller,
    @required this.onSuggestionTeamCallback,
    @required this.teamCategoriesCallback,
//    @required this.onSave,
    this.maxWidth
  }) : assert(player != null);

  @override
  State<StatefulWidget> createState() => _PlayerDetailLayoutState(controller);

}

class _PlayerDetailLayoutState extends State<PlayerDetailLayout> {

  bool editEnabled;

  Player tempPlayer;

  TextEditingController nameTextController, surnameTextController,
      heightTextController, weightTextController;

  String roleText, footText;
  TextEditingController matchesTextController, goalsTextController,
      yellowTextController, redTextController;

  TextEditingController morfologiaTextController, sommatoTipoTextController;

  TextEditingController attitude1TextController, attitude2TextController,
      attitude3TextController;

  _PlayerDetailLayoutState(PlayerDetailController controller) {
    controller.savePlayerStatus = savePlayerState;
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

    tempPlayer = widget.player;
    reset();

  }

  @override
  void didUpdateWidget(covariant PlayerDetailLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    editEnabled = widget.isEditEnabled;
    tempPlayer = widget.player;
    if(oldWidget.isEditEnabled != widget.isEditEnabled)
      reset();
  }

  void reset() {
//    tempPlayer = Player.clone(widget.player);
//    tempPlayer = widget.player;

    nameTextController.text = tempPlayer.name;
    surnameTextController.text = tempPlayer.surname;
    heightTextController.text = tempPlayer.height.toString();
    weightTextController.text = tempPlayer.weight.toString();

    roleText = Player.positionToString(tempPlayer.position);
    footText = tempPlayer.isRightHanded ? "Destro" : "Sinistro";
    matchesTextController.text = tempPlayer.matches.toString();
    goalsTextController.text = tempPlayer.goals.toString();
    yellowTextController.text = tempPlayer.yellowCards.toString();
    redTextController.text = tempPlayer.redCards.toString();

    morfologiaTextController.text = tempPlayer.morfologia;
    sommatoTipoTextController.text = tempPlayer.sommatoTipo;

    attitude1TextController.text = tempPlayer.attitudine1;
    attitude2TextController.text = tempPlayer.attitudine2;
    attitude3TextController.text = tempPlayer.attitudine3;
  }

  void savePlayerState() {
    //TODO Check if there are not textfields with errors

    tempPlayer.name = nameTextController.text;
    tempPlayer.surname = surnameTextController.text;
    tempPlayer.height = int.tryParse(heightTextController.text);
    tempPlayer.weight = int.tryParse(weightTextController.text);

    tempPlayer.position = Player.stringToPosition(roleText);
    tempPlayer.isRightHanded = footText == "Destro" ? true : false;
    tempPlayer.matches = int.tryParse(matchesTextController.text);
    tempPlayer.goals = int.tryParse(goalsTextController.text);
    tempPlayer.yellowCards = int.tryParse(yellowTextController.text);
    tempPlayer.redCards = int.tryParse(redTextController.text);

    tempPlayer.morfologia = morfologiaTextController.text;
    tempPlayer.sommatoTipo = sommatoTipoTextController.text;
    tempPlayer.attitudine1 = attitude1TextController.text;
    tempPlayer.attitudine2 = attitude2TextController.text;
    tempPlayer.attitudine3 = attitude3TextController.text;
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
              playerInfo(context, editEnabled, tempPlayer, nameTextController, surnameTextController, heightTextController, weightTextController),
              playerCharacteristics(context, tempPlayer, editEnabled, roleText, footText, matchesTextController, goalsTextController, yellowTextController, redTextController,
              morfologiaTextController, sommatoTipoTextController, attitude1TextController, attitude2TextController, attitude3TextController),
            ],
          ),
        ),
      ),
    );
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

    return Container(
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
                    CustomRichText(
                      onTap: () async {
                        // se faccio cambiare squadra, fare un metodo nel team repository per rimuovere il player id dal team's playerIds
                        // e poi salvare il player nella nuova squadra (fatto, gestito nel savePlayer di databaseService)
                        if(isEditEnabled) {
                          Team team = await _showInsertTeamDialog(playerInfo.teamName);
                          if(team != null) {
                            setState(() {
                              playerInfo.setTeam(team);
                            });
                          }
                          // close dialog
                          Navigator.of(context).pop();
                        }
                      },
                      enabled: isEditEnabled,
                      text: playerInfo.teamName,
                      textAlign: TextAlign.start,
                      fontColor: playerTeamTextColor,
                      fontSize: playerTeamTextSize,
                      fontWeight: playerTeamTextWeight,
                    ),
                    CustomRichText(
                      onTap: () async {
                        // se cambia categoria serve solo aggiornare il player (ma può servire aggiungere una nuova categoria alla squadra nel caso
                        // il player ora faccia parte di una categoria di cui ancora il team non era presente) -> no non serve
                        if(isEditEnabled) {
                          List<Category> categories = await widget.teamCategoriesCallback(playerInfo.getTeam());
                          final dialog = SelectCategoryDialog(
                              categories: categories,
                              onSelect: (newCategory) {
                                if(newCategory != null) {
                                  setState(() {
                                    playerInfo.setCategory(newCategory);
                                  });
                                }
                                // close dialog
                                Navigator.of(context).pop();
                              }
                          );
                          dialog.showSelectCategoryDialog(context);
                        }
                      },
                      enabled: isEditEnabled,
                      text: playerInfo.categoryName,
                      textAlign: TextAlign.start,
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
                      child: GestureDetector(
                        onTap: () async {
                          if (isEditEnabled) {
                            DateTime curDate = DateTime.now();
                            await showDatePicker(
                                context: context,
                                initialDate: playerInfo.birthDay,
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
                                  playerInfo.birthDay = date;
                                });
                            });
                          }
                        },
                        child: Text(
                          "${playerInfo.birthDay.day} ${Utils
                              .monthToString(
                              playerInfo.birthDay.month).substring(
                              0, 3)} ${playerInfo.birthDay.year}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: playerHeightTextColor,
                            fontSize: playerHeightTextSize,
                            fontWeight: playerHeightTextWeight,
                          ),
                        ),
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
    );
  }

  Widget playerCharacteristics(BuildContext context, Player playerInfo, bool isEditEnabled, String roleText, String footText,
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
              statElement(context, PlayerDetailLayout.STAT_ROLE, "Ruolo", isEditEnabled, false, elementText: roleText),
              statElement(context, PlayerDetailLayout.STAT_FOOT, "Piede", isEditEnabled, false, elementText: footText),
              statElement(context, PlayerDetailLayout.STAT_MATCHES, "Presenze", isEditEnabled, true, elementController: matchesTextController),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              statElement(context, PlayerDetailLayout.STAT_GOALS, "Gol", isEditEnabled, true, elementController: goalsTextController),
              statElement(context, PlayerDetailLayout.STAT_YELLOW_CARDS, "Gialli", isEditEnabled, true, elementController: yellowTextController),
              statElement(context, PlayerDetailLayout.STAT_RED_CARDS, "Rossi", isEditEnabled, true, elementController: redTextController),
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

  Widget statElement(BuildContext context, int icon, String elementName, bool isEditEnabled, bool isFreeText, {TextEditingController elementController, String elementText}) {
    String iconPath = "assets/images/${_mapStatToIcon(icon)}";

    List<String> positionChoices = [Player.positionToString(Player.POSITION_GOALKEEPER),
      Player.positionToString(Player.POSITION_DEFENDER), Player.positionToString(Player.POSITION_MIDFIELDER),
      Player.positionToString(Player.POSITION_FORWARD)];

    List<String> footChoices = ["Destro", "Sinistro"];

    Widget elementWidget;
    if(isFreeText) {
      // the text can be edited manually
      elementWidget = CustomTextField(
        width: 30,
        enabled: isEditEnabled,
        controller: elementController,
        textAlign: TextAlign.center,
        maxLines: 1,
        textInputType: TextInputType.number,
        textColor: Colors.black,
        textFontSize: 14,
        textFontWeight: FontWeight.normal,
      );
    } else {
      // the value can only assume some values
      elementWidget = Text(
        elementText,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
          fontWeight: FontWeight.normal,
        ),
      );
    }

    return GestureDetector(
      onTap: () async {
        if(!isFreeText && isEditEnabled) {
          // show dialog

          bool isPositionChoice = icon == PlayerDetailLayout.STAT_ROLE;

          String title = isPositionChoice ? "Seleziona il ruolo del giocatore" : "Seleziona il piede preferito del giocatore";
          List<String> choices = isPositionChoice ? positionChoices : footChoices;

          await showStatElementChoiceDialog(context, title, choices, (index)
          {
            setState(() {
              elementText = choices[index];
              // Direct assignment to global variables because elementText is not overwriting them
              if(icon == PlayerDetailLayout.STAT_ROLE)
                roleText = elementText;
              if(icon == PlayerDetailLayout.STAT_FOOT)
                footText = elementText;
            });
          }, isPositionChoice ? 250 : 150);
        }
      },
      child: Container(
        margin: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: SvgPicture.asset(
                    iconPath,
                  ),
                  height: 24,
                  width: 24,
                ),
                SizedBox(width: 5,),
                Text(
                  elementName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: blueAgonisticaColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            elementWidget
          ],
        ),
      ),
    );
  }

  Future<void> showStatElementChoiceDialog(BuildContext context, String title, List<String> choices, Function(int) onChoiceSelect, double height) async {
    await showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blueAgonisticaColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        material: (_, __) => MaterialAlertDialogData(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            )
        ),
        content: Container(
          width: 0.9 * MediaQuery.of(context).size.width,
          height: height,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: choices.length,
              itemBuilder: (ctx, index) {
                return ListTile(
                  onTap: () {
                    onChoiceSelect(index);

                    // close dialog
                    Navigator.of(context).pop();
                  },
                  title: Text(
                    choices[index],
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }

  Widget playerCharacteristicsBox(Player playerInfo, bool isEditEnabled) {

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
    double doubleValue = value.toDouble();

    Widget element;
    if(isEditEnabled) {
      element = Slider(
        min: Player.MIN_VALUE.toDouble(),
        max: Player.MAX_VALUE.toDouble(),
        divisions: Player.MAX_VALUE,
        label: value.round().toString(),
        value: doubleValue,
        onChanged: (v) {
          onChange(v.toInt());
          setState(() {
            doubleValue = v;
          });
        },
        activeColor: blueAgonisticaColor,
        inactiveColor: blueLightAgonisticaColor,
      );
    } else {
      element = circlesBar(value, Player.MAX_VALUE, width);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            statName,
            textAlign: TextAlign.start,
            style: TextStyle(
              color: blueAgonisticaColor,
              fontSize: 16,
              fontWeight: FontWeight.normal
            ),
          ),
          element
        ],
      ),
    );
  }

  Widget circlesBar(int value, int numCircles, double maxWidth) {
    double size = 0.7 * maxWidth / Player.MAX_VALUE;
    List<int> circles = List.generate(numCircles, (index) => index);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: blueAgonisticaColor),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
//      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: circles.map((index) {
          return Container(
            margin: EdgeInsets.symmetric(horizontal: 1),
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: index < value ? blueAgonisticaColor : blueAgonisticaColor.withOpacity(0.38),
              shape: BoxShape.circle,
            ),
          );
        }).toList(),
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
            tempTeam = finalTeamValue;
          }
        }
    );
    await insertTeamDialog.showInsertTeamDialog(context);
    return tempTeam;
  }

  static String _mapStatToIcon(int icon) {
    switch(icon) {
      case PlayerDetailLayout.STAT_ROLE: return '013-football-1.svg';
      case PlayerDetailLayout.STAT_FOOT: return '006-footwear.svg';
      case PlayerDetailLayout.STAT_MATCHES: return '027-match.svg';
      case PlayerDetailLayout.STAT_GOALS: return '050-soccer-ball.svg';
      case PlayerDetailLayout.STAT_YELLOW_CARDS: return '018-yellow-card.svg';
      case PlayerDetailLayout.STAT_RED_CARDS: return '026-red-card.svg';
      default: return "";
    }
  }

}

class PlayerDetailController {

  void Function() savePlayerStatus;

}