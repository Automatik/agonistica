import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/shared/player_text_form_field.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PlayerItemEditDialog {

  final MatchPlayerData matchPlayerData;
  final Function onSaveCallback;

  PlayerItemEditDialog({
    @required this.matchPlayerData,
    this.onSaveCallback,
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
          onSaveCallback: onSaveCallback,
        ),
      )
    );
  }

}

class _PlayerItemDialogForm extends StatefulWidget {

  final MatchPlayerData matchPlayerData;
  final Function onSaveCallback;

  _PlayerItemDialogForm({
    @required this.matchPlayerData,
    this.onSaveCallback,
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
  final TextEditingController shirtTextEditingController = TextEditingController();
  final TextEditingController nameTextEditingController = TextEditingController();
  final TextEditingController surnameTextEditingController = TextEditingController();
  int goals = 0;
  int card;
  int substitution;

  @override
  void initState() {
    super.initState();
    nameTextEditingController.text = widget.matchPlayerData.name ?? "";
    surnameTextEditingController.text = widget.matchPlayerData.surname ?? "";
    int shirt = widget.matchPlayerData.shirtNumber ?? 1;
    shirtTextEditingController.text = "$shirt";
    goals = widget.matchPlayerData.numGoals ?? 0;
    card = widget.matchPlayerData.card ?? MatchPlayerData.CARD_NONE;
    substitution = widget.matchPlayerData.substitution ?? MatchPlayerData.SUBSTITUTION_NONE;
  }

  void onSave() {
    if(areShirtNameAndSurnameValid()) {
      // the other fields (goals and dropdown) are always valid
      widget.matchPlayerData.name = nameTextEditingController.text;
      widget.matchPlayerData.surname = surnameTextEditingController.text;
      widget.matchPlayerData.shirtNumber = int.tryParse(shirtTextEditingController.text);
      widget.matchPlayerData.numGoals = goals;
      widget.matchPlayerData.card = card;
      widget.matchPlayerData.substitution = substitution;

      if(widget.onSaveCallback != null)
        widget.onSaveCallback.call();
    }
  }

  bool areShirtNameAndSurnameValid() {
    return _formKey.currentState.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 0.6 * MediaQuery.of(context).size.height,
      ),
      width: 0.9 * MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          playerShirtAndNameForm(),
          playerGoalCardAndSub(),
          okButton(),
        ],
      ),
    );
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
              flex: 4,
              child: nameTextForm(border),
            ),
            Expanded(
              flex: 4,
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

  Widget okButton() {
    return GestureDetector(
      onTap: () => onSave(),
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
        labelSvgIconPath: "assets/images/029-football-jersey.svg",
        fontSize: formFontSize,
        fontWeight: formFontWeight,
        fontColor: formFontColor,
        maxErrorLines: formErrorMaxLines,
        textInputType: TextInputType.number,
        onChanged: (value) {
          print("shirt onChanged value: $value");
        },
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
        onChanged: (value) {
          print("name onChanged value: $value");
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
        onChanged: (value) {
          print("name onChanged value: $value");
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