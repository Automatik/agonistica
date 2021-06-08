// @dart=2.9

import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/widgets/text/player_text_form_field.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:uuid/uuid.dart';

class PlayerItemEditDialog {

  final MatchPlayerData matchPlayerData;
  final bool Function(String, int) onPlayerValidation;
  final Function(MatchPlayerData) onSaveCallback;
  final List<SeasonPlayer> Function(String, String) suggestionCallback;

  PlayerItemEditDialog({
    @required this.matchPlayerData,
    @required this.onPlayerValidation,
    this.onSaveCallback,
    @required this.suggestionCallback,
  });

  Future<void> showPlayerItemEditDialog(BuildContext context) async {
    await showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(
          "Modifica Giocatore",
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
        content: _PlayerItemDialogForm(
          matchPlayerData: matchPlayerData,
          onPlayerValidation: onPlayerValidation,
          onSaveCallback: onSaveCallback,
          suggestionCallback: suggestionCallback,
        ),
      )
    );
  }

}

class _PlayerItemDialogForm extends StatefulWidget {

  final MatchPlayerData matchPlayerData;
  final bool Function(String, int) onPlayerValidation;
  final Function onSaveCallback;
  final List<SeasonPlayer> Function(String, String) suggestionCallback;

  _PlayerItemDialogForm({
    @required this.matchPlayerData,
    @required this.onPlayerValidation,
    this.onSaveCallback,
    @required this.suggestionCallback,
  });

  @override
  State<StatefulWidget> createState() => _PlayerItemEditDialogFormState();

}

class _PlayerItemEditDialogFormState extends State<_PlayerItemDialogForm> {

  final int formErrorMaxLines = 3;
  final double formFontSize = 16;
  final FontWeight formFontWeight = FontWeight.normal;
  final Color formFontColor = blueAgonisticaColor;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _nameTextFocusNode = FocusNode();
  final FocusNode _surnameTextFocusNode = FocusNode();
  String _formErrorMessage;
  bool _isFormError;
  bool _isLoadingPlayersSuggestions;
  bool _isTextFocused;
  List<SeasonPlayer> _playersSuggestionsList;

  final TextEditingController shirtTextEditingController = TextEditingController();
  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController surnameTextEditingController = TextEditingController();
  int goals = 0;
  int card;
  int substitution;

  @override
  void initState() {
    super.initState();
    _isFormError = false;
    _isTextFocused = false;
    _nameTextFocusNode.addListener(onTextFocusChange);
    _surnameTextFocusNode.addListener(onTextFocusChange);

    nameTextEditingController.text = initializeName(widget.matchPlayerData.name);
    surnameTextEditingController.text = initializeSurname(widget.matchPlayerData.surname);
    int shirt = widget.matchPlayerData.shirtNumber ?? 1;
    shirtTextEditingController.text = "$shirt";
    goals = widget.matchPlayerData.numGoals ?? 0;
    card = widget.matchPlayerData.card ?? MatchPlayerData.CARD_NONE;
    substitution = widget.matchPlayerData.substitution ?? MatchPlayerData.SUBSTITUTION_NONE;
  }

  String initializeName(String name) {
    return (name == null || name == MatchPlayerData.EMPTY_PLAYER_NAME) ? "" : name;
  }

  String initializeSurname(String surname) {
    return (surname == null || surname == MatchPlayerData.EMPTY_PLAYER_SURNAME) ? "" : surname;
  }

  void onSave(BuildContext context) {
    if(areShirtNameAndSurnameValid()) {
      // the other fields (goals and dropdown) are always valid

      String seasonPlayerId = widget.matchPlayerData.seasonPlayerId;
      String name = nameTextEditingController.text;
      String surname = surnameTextEditingController.text;
      int shirtNumber = int.tryParse(shirtTextEditingController.text);

      if(widget.onPlayerValidation(widget.matchPlayerData.id, shirtNumber)) {

        avoidDuplicateMatchPlayer();

        MatchPlayerData newPlayerData = MatchPlayerData.clone(widget.matchPlayerData);

        // If matchPlayerData.playerId is not set by onItemPlayerTap method
        // then it's a new player
        if(!isExistingPlayer(seasonPlayerId)) {
          var uuid = Uuid();
          seasonPlayerId = uuid.v4();
          newPlayerData.seasonPlayerId = seasonPlayerId;
        }

        newPlayerData.name = name;
        newPlayerData.surname = surname;
        newPlayerData.shirtNumber = shirtNumber;
        newPlayerData.numGoals = goals;
        newPlayerData.card = card;
        newPlayerData.substitution = substitution;

        if (widget.onSaveCallback != null) {
          widget.onSaveCallback(newPlayerData);
        }

        Navigator.of(context, rootNavigator: true).pop();

      } else {
        setState(() {
          _isFormError = true;
          _formErrorMessage = "E' già presente un giocatore con questo numero di maglia.";
        });
      }
    }
  }

  bool isExistingPlayer(String seasonPlayerId) {
    return seasonPlayerId != null;
  }
  
  /// If the user write manually the name and surname of an existing player
  /// this method allows to get the player's id
  String avoidDuplicateMatchPlayer() {
    String seasonPlayerId = widget.matchPlayerData.seasonPlayerId;
    if(!ALLOW_DUPLICATE_MATCH_PLAYERS || isExistingPlayer(seasonPlayerId)) {
      return seasonPlayerId;
    }
    String name = nameTextEditingController.text;
    String surname = surnameTextEditingController.text;
    loadPlayersSuggestions(MatchPlayerData.EMPTY_PLAYER_NAME, MatchPlayerData.EMPTY_PLAYER_SURNAME);
    int index = _playersSuggestionsList.indexWhere((p) => p.getPlayerName() == name && p.getPlayerSurname() == surname);
    return index == -1 ? seasonPlayerId : _playersSuggestionsList[index].id;
  }

  bool areShirtNameAndSurnameValid() {
    return _formKey.currentState.validate();
  }

  void onTextFocusChange() {
    _isTextFocused = _nameTextFocusNode.hasFocus || _surnameTextFocusNode.hasFocus;
    if(_isTextFocused) {
      _isLoadingPlayersSuggestions = true;

      String namePattern = nameTextEditingController.text;
      String surnamePattern = surnameTextEditingController.text;
      loadPlayersSuggestions(namePattern, surnamePattern);
    }
  }

  void loadPlayersSuggestions(String namePattern, String surnamePattern) {
    if(namePattern == MatchPlayerData.EMPTY_PLAYER_NAME)
      namePattern = "";
    if(surnamePattern == MatchPlayerData.EMPTY_PLAYER_SURNAME)
      surnamePattern = "";
    _playersSuggestionsList = widget.suggestionCallback(namePattern, surnamePattern);
    setState(() {
      _isLoadingPlayersSuggestions = false;
    });
  }

  /// The onChanged method in TextField is called only when writing through the
  /// keyboard and it's not called when selecting the player through the
  /// playersSuggestionsList. This method prevents from using the playerId of an
  /// existing player when writing something in the textfield, even after
  /// selecting a player.
  /// Example: Start writing a name in the textfield, click on a suggested
  /// player and then add a letter to the name.
  void updateMatchPlayerData() {
    widget.matchPlayerData.seasonPlayerId = null;
  }

  void onItemPlayerTap(SeasonPlayer seasonPlayer) {
    widget.matchPlayerData.seasonPlayerId = seasonPlayer.id;
    this.nameTextEditingController.text = seasonPlayer.getPlayerName();
    this.surnameTextEditingController.text = seasonPlayer.getPlayerSurname();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 0.6 * MediaQuery.of(context).size.height,
      ),
      width: 0.9 * MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: dialogContent(context),
      )
    );
  }

  Widget dialogContent(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        errorMessage(),
        playerShirtAndNameForm(),
        playersSuggestions(),
        playerGoalCardAndSub(),
        okButton(context),
      ],
    );
  }

  Widget errorMessage() {
    if(!_isFormError) {
      return SizedBox();
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Text(
          _formErrorMessage,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.red,
            fontWeight: FontWeight.normal,
          ),
        ),
      );
    }
  }

  Widget playerShirtAndNameForm() {

    InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: blueAgonisticaColor),
    );

    return Form(
      key: _formKey,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              flex: 1,
              child: shirtTextForm(border),
            ),
            Expanded(
              flex: 3,
              child: nameTextForm(border),
            ),
            Expanded(
              flex: 3,
              child: surnameTextForm(border),
            ),
          ],
        ),
      ),
    );
  }

  Widget playerGoalCardAndSub() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: labelTextWidget("Gol", 24, formFontSize, formFontColor)
                ),
              ),
              Expanded(
                flex: 2,
                child: Container(
                  child: labelTextWidget("Cartellino", 24, formFontSize, formFontColor)
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  flex: 1,
                  child: goalForm()
              ),
              Expanded(
                  flex: 2,
                  child: cardForm()
              ),
            ],
          ),
          Container(
            child: labelTextWidget("Sostituzione", 24, formFontSize, formFontColor),
          ),
          substitutionForm(),
        ],
      )
    );
  }

  Widget okButton(BuildContext context) {
    return GestureDetector(
      onTap: () => onSave(context),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: blueAgonisticaColor,
        ),
        child: Text(
          "OK",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: formFontSize,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget shirtTextForm(InputBorder border) {
    return Container(
      margin: const EdgeInsets.only(right: 5),
      child: PlayerTextFormField(
        controller: shirtTextEditingController,
        labelSvgIconPath: IconAssets.ICON_FOOTBALL_JERSEY,
        fontSize: formFontSize,
        fontWeight: formFontWeight,
        fontColor: formFontColor,
        maxErrorLines: formErrorMaxLines,
        textInputType: TextInputType.number,
        validator: (value) => InputValidation.validatePlayerShirtNumber(value),
      ),
    );
  }

  Widget nameTextForm(InputBorder border) {
    return Container(
      margin: const EdgeInsets.only(left: 5, right: 5),
      child: PlayerTextFormField(
        controller: nameTextEditingController,
        labelText: "Nome",
        fontSize: formFontSize,
        fontWeight: formFontWeight,
        fontColor: formFontColor,
        maxErrorLines: formErrorMaxLines,
        focusNode: _nameTextFocusNode,
        onChanged: (value) {
          bool isNameValid = InputValidation.validatePlayerName(value) == null;
          if(isNameValid) {
            updateMatchPlayerData();
            loadPlayersSuggestions(value, surnameTextEditingController.text);
          }
        },
        validator: (value) => InputValidation.validatePlayerName(value),
      ),
    );
  }

  Widget surnameTextForm(InputBorder border) {
    return Container(
      margin: const EdgeInsets.only(left: 5),
      child: PlayerTextFormField(
        controller: surnameTextEditingController,
        labelText: "Cognome",
        fontSize: formFontSize,
        fontWeight: formFontWeight,
        fontColor: formFontColor,
        maxErrorLines: formErrorMaxLines,
        focusNode: _surnameTextFocusNode,
        onChanged: (value) {
          bool isSurnameValid = InputValidation.validatePlayerSurname(value) == null;
          if(isSurnameValid) {
            updateMatchPlayerData();
            loadPlayersSuggestions(nameTextEditingController.text, value);
          }
        },
        validator: (value) => InputValidation.validatePlayerSurname(value),
      ),
    );
  }

  Widget goalForm() {

    final double iconsSize = 20;

    final boxDecoration = BoxDecoration(
        shape: BoxShape.rectangle,
        border: Border.all(color: blueAgonisticaColor, width: 1)
    );

    return Container(
      margin: const EdgeInsets.only(left: 5, top: 12, right: 5, bottom: 5), //align with the label
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if(goals > 0) {
                setState(() {
                  goals--;
                });
              }
            },
            child: Container(
              decoration: boxDecoration,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 9),
              child: Container(
                width: iconsSize / 2,
                height: iconsSize / 8,
                color: blueAgonisticaColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: boxDecoration,
            child: Text(
              "$goals",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: formFontSize,
                  fontWeight: formFontWeight,
                  color: formFontColor
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              int maxLimitGoalsMatch = 99;
              if(goals <= maxLimitGoalsMatch) {
                setState(() {
                  goals++;
                });
              }
            },
            child: Container(
              decoration: boxDecoration,
              child: Icon(Icons.add, size: iconsSize, color: blueAgonisticaColor,),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardForm() {
    final List<int> items = [
      MatchPlayerData.CARD_NONE,
      MatchPlayerData.CARD_YELLOW,
      MatchPlayerData.CARD_DOUBLE_YELLOW,
      MatchPlayerData.CARD_RED,
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: DropdownButton<int>(
        value: card,
        isExpanded: true,
        items: items.map((item) {
          return DropdownMenuItem<int>(
            child: DropdownCardItem(
              card: item,
              fontSize: formFontSize,
            ),
            value: item,
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            print("value dropdown: $value");
            card = value;
          });
        },
      ),
    );
  }

  Widget substitutionForm() {
    final List<int> items = [
      MatchPlayerData.SUBSTITUTION_NONE,
      MatchPlayerData.SUBSTITUTION_ENTERED,
      MatchPlayerData.SUBSTITUTION_EXITED,
    ];
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      constraints: BoxConstraints(
        maxWidth: 150,
      ),
      child: DropdownButton<int>(
        value: substitution,
        isExpanded: true,
        items: items.map((item) {
          return DropdownMenuItem<int>(
            child: DropdownSubstitutionItem(
              substitution: item,
              fontSize: formFontSize,
            ),
            value: item,
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            substitution = value;
          });
        },
      ),
    );
  }

  Widget labelTextWidget(String text, double height, double fontSize, Color color) {
    return  Container(
      alignment: Alignment.center,
      height: height,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget playersSuggestions() {
    if(_isTextFocused) {
      Widget widget;
      if(_isLoadingPlayersSuggestions) {
        widget = indicator();
      } else {
        if(_playersSuggestionsList.isEmpty) {
          widget = SizedBox();
        } else {
          widget = playersListView(_playersSuggestionsList);
        }
      }
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            widget,
          ]
      );
    } else {
      return SizedBox();
    }
  }

  Widget indicator() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(blueAgonisticaColor),
        strokeWidth: 4,
      ),
    );
  }

  Widget playersListView(List<SeasonPlayer> seasonPlayers) {
    return Expanded(
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 10, top: 10, right: 5),
            alignment: Alignment.centerLeft,
            child: Text(
              "Giocatori squadra esistenti",
              textAlign: TextAlign.start,
              style: TextStyle(
                color: blueAgonisticaColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            constraints: BoxConstraints(
              minHeight: 100,
              maxHeight: 150,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: blueAgonisticaColor),
            ),
            child: ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: seasonPlayers.length,
                itemBuilder: (context, index) {
                  String playerName = seasonPlayers[index].getPlayerName();
                  String playerSurname = seasonPlayers[index].getPlayerSurname();
                  return ListTile(
                    onTap: () => onItemPlayerTap(seasonPlayers[index]),
                    title: Text(
                      "$playerName $playerSurname",
                      style: TextStyle(
                        color: blueAgonisticaColor,
                        fontSize: 14,
                      ),
                    ),
                    dense: true,
                  );
                }
            ),
          ),
        ]
      ),
    );
  }

}

class DropdownCardItem extends StatelessWidget {

  final int card;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;

  DropdownCardItem({
    @required this.card,
    this.iconSize = 20,
    @required this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          cardIcon(),
          Flexible(
            child: cardText()
          ),
        ],
      ),
    );
  }

  Widget cardIcon() {
    String assetName = MatchPlayerData.getCardAsset(card);
    Widget icon;
    if(assetName.isEmpty)
      icon = SizedBox(width: iconSize, height: iconSize,);
    else
      icon = SvgPicture.asset(assetName);

    return Container(
      width: iconSize,
      height: iconSize,
      child: icon,
    );
  }

  Widget cardText() {
    String text = MatchPlayerData.getCardText(card);
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        overflow: TextOverflow.visible,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }

}

class DropdownSubstitutionItem extends StatelessWidget {

  final int substitution;
  final double iconSize;
  final double fontSize;
  final FontWeight fontWeight;

  DropdownSubstitutionItem({
    @required this.substitution,
    this.iconSize = 20,
    this.fontSize,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          substitutionIcon(),
          Flexible(
              child: substitutionText()
          ),
        ],
      ),
    );
  }

  Widget substitutionIcon() {
    String assetName = MatchPlayerData.getSubstitutionAsset(substitution);
    Widget icon;
    if(assetName.isEmpty)
      icon = SizedBox(width: iconSize, height: iconSize,);
    else
      icon = SvgPicture.asset(assetName);

    return Container(
      width: iconSize,
      height: iconSize,
      child: icon,
    );
  }

  Widget substitutionText() {
    String text = MatchPlayerData.getSubstitutionText(substitution);
    return Container(
      margin: const EdgeInsets.only(left: 5),
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        overflow: TextOverflow.visible,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
        ),
      ),
    );
  }

}