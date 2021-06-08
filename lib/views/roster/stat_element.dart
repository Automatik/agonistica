// @dart=2.9

import 'package:agonistica/core/assets/icon_assets.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/widgets/text/custom_text_field.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/views/roster/player_detail_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatElement extends StatefulWidget {

  final int icon;
  final String elementName;
  final bool isEditEnabled;
  final bool isFreeText;
  final TextEditingController elementController;
  final String elementText;
  final Function(String) onElementChange;

  StatElement({
    @required this.icon,
    @required this.elementName,
    @required this.isEditEnabled,
    @required this.isFreeText,
    @required this.onElementChange,
    this.elementController,
    this.elementText
  });

  @override
  State<StatefulWidget> createState() => _StatElementState();

}

class _StatElementState extends State<StatElement> {

  String elementTextState;

  @override
  void initState() {
    super.initState();
    elementTextState = widget.elementText;
  }

  @override
  Widget build(BuildContext context) {
    String iconPath = _mapStatToIcon(widget.icon);

    List<String> positionChoices = [SeasonPlayer.positionToString(SeasonPlayer.POSITION_GOALKEEPER),
      SeasonPlayer.positionToString(SeasonPlayer.POSITION_DEFENDER), SeasonPlayer.positionToString(SeasonPlayer.POSITION_MIDFIELDER),
      SeasonPlayer.positionToString(SeasonPlayer.POSITION_FORWARD)];

    List<String> footChoices = ["Destro", "Sinistro"];

    Widget elementWidget;
    if(widget.isFreeText) {
      // the text can be edited manually
      elementWidget = CustomTextField(
        width: 30,
        enabled: widget.isEditEnabled,
        controller: widget.elementController,
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
        elementTextState,
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
        if(!widget.isFreeText && widget.isEditEnabled) {
          // show dialog

          bool isPositionChoice = widget.icon == PlayerDetailLayout.STAT_ROLE;

          String title = isPositionChoice ? "Seleziona il ruolo del giocatore" : "Seleziona il piede preferito del giocatore";
          List<String> choices = isPositionChoice ? positionChoices : footChoices;

          await showStatElementChoiceDialog(context, title, choices, (index)
          {
            setState(() {
              elementTextState = choices[index];
            });
            if(widget.onElementChange != null) {
              widget.onElementChange(elementTextState);
            }
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
                  widget.elementName,
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

  static String _mapStatToIcon(int icon) {
    switch(icon) {
      case PlayerDetailLayout.STAT_ROLE: return IconAssets.ICON_KICKING_BALL;
      case PlayerDetailLayout.STAT_FOOT: return IconAssets.ICON_FOOTWEAR;
      case PlayerDetailLayout.STAT_MATCHES: return IconAssets.ICON_MATCH_CALENDAR;
      case PlayerDetailLayout.STAT_GOALS: return IconAssets.ICON_FOOTBALL_BALL_OUTLINED;
      case PlayerDetailLayout.STAT_YELLOW_CARDS: return IconAssets.ICON_YELLOW_CARD;
      case PlayerDetailLayout.STAT_RED_CARDS: return IconAssets.ICON_RED_CARD;
      default: return "";
    }
  }

}