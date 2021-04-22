import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/widgets/popups/player_item_popup_menu.dart';
import 'package:agonistica/widgets/popups/popup_menu_item_tile.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/widgets/dialogs/player_item_edit_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double ICON_SIZE = 20;
const double ICON_HORIZ_MARGIN = 2.5;

class PlayerItem extends StatelessWidget {

  final MatchPlayerData matchPlayer;
  final bool isLeftOrientation;
  final bool isEditEnabled;
  final bool Function(String, int) onPlayerValidation;
  final List<SeasonPlayer> Function(String, String) onPlayersSuggestionCallback;
  final void Function(MatchPlayerData) onSaveCallback;
  final void Function(MatchPlayerData) onViewPlayerCardCallback;
  final void Function(MatchPlayerData) onDeleteCallback;

  PlayerItem({
    @required this.matchPlayer,
    @required this.isLeftOrientation,
    @required this.isEditEnabled,
    @required this.onPlayerValidation,
    @required this.onPlayersSuggestionCallback,
    @required this.onSaveCallback,
    @required this.onViewPlayerCardCallback,
    @required this.onDeleteCallback,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPlayerItemClick(context),
      onLongPressStart: (longPressDetails) => onPlayerItemLongClick(context, longPressDetails.globalPosition),
      child: Container(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: playerData(),
        ),
      ),
    );
  }

  Future<void> onPlayerItemClick(BuildContext context) async {
    if(!isEditEnabled) {
      return;
    }
    final dialog = PlayerItemEditDialog(
      matchPlayerData: matchPlayer,
      onPlayerValidation: onPlayerValidation,
      onSaveCallback: onSaveCallback,
      suggestionCallback: onPlayersSuggestionCallback,
    );
    await dialog.showPlayerItemEditDialog(context);
  }

  Future<void> onPlayerItemLongClick(BuildContext context, Offset offset) async {
    if(!shouldShowMenu()) {
      return;
    }
    final playerItemPopupMenu = PlayerItemPopupMenu(offset: offset);
    int value = await playerItemPopupMenu.showPopupMenu(context);
    selectLongClickAction(value);
  }

  bool shouldShowMenu() {
    return isEditEnabled && !matchPlayer.isEmptyPlayer();
  }

  void selectLongClickAction(int value) {
    switch(value) {
      case PlayerItemPopupMenu.VIEW_PLAYER_CARD: onViewPlayerCardCallback(matchPlayer); break;
      case PlayerItemPopupMenu.DELETE_PLAYER: onDeleteCallback(matchPlayer); break;
      default: return;
    }
  }

  List<Widget> playerData() {
    List<Widget> widgets = [
      Expanded(
        flex: 1,
        child: playerShirtNumber(),
      ),
      Expanded(
        flex: 3,
        child: playerName(),
      ),
      Expanded(
        flex: 3,
        child: Row(
          mainAxisAlignment: isLeftOrientation ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: playerItems(),
        ),
      ),
    ];
    return reverseListBasedOnOrientation(widgets, isLeftOrientation);
  }

  Widget playerShirtNumber() {
    return _PlayerItemShirtNumber(
      shirtNumber: matchPlayer.shirtNumber,
      isLeftOrientation: isLeftOrientation,
    );
  }

  Widget playerName() {
    return _PlayerItemName(
      playerName: matchPlayer.name,
      playerSurname: matchPlayer.surname,
      isLeftOrientation: isLeftOrientation,
    );
  }

  List<Widget> playerItems() {
    List<Widget> widgets = [];
    widgets.add(
      Expanded(
        flex: 1,
        child: _SubstitutionItem(
          substitution: matchPlayer.substitution,
        ),
      ),
    );
    widgets.add(
      Expanded(
        flex: 1,
        child: _CardItem(
          card: matchPlayer.card,
        ),
      ),
    );
    widgets.add(
      Expanded(
        flex: 1,
        child: _GoalItem(
            goals: matchPlayer.numGoals
        ),
      ),
    );
    return reverseListBasedOnOrientation(widgets, isLeftOrientation);
  }

  static List<Widget> reverseListBasedOnOrientation(List<Widget> widgets, bool isLeftOrientation) {
    if(isLeftOrientation)
      return widgets;
    else
      return widgets.reversed.toList();
  }

}

class _PlayerItemShirtNumber extends StatelessWidget {

  final int shirtNumber;
  final bool isLeftOrientation;

  final double fontSize = 16;
  final FontWeight fontWeight = FontWeight.normal;
  final Color fontColor = Colors.black;

  _PlayerItemShirtNumber({
    this.shirtNumber,
    this.isLeftOrientation,
  });

  @override
  Widget build(BuildContext context) {
    String playerShirtNumber = shirtNumberToString(shirtNumber);

    return Text(
      playerShirtNumber,
      textAlign: isLeftOrientation ? TextAlign.start : TextAlign.end,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );
  }

  String shirtNumberToString(int shirtNumber) {
    return (shirtNumber > 0 && shirtNumber < 100) ? "$shirtNumber" : "-";
  }

}

class _PlayerItemName extends StatelessWidget {

  final String playerName;
  final String playerSurname;
  final bool isLeftOrientation;

  final double fontSize = 16;
  final FontWeight fontWeight = FontWeight.normal;
  final Color fontColor = Colors.black;

  _PlayerItemName({
    this.playerName,
    this.playerSurname,
    this.isLeftOrientation,
  });

  @override
  Widget build(BuildContext context) {

    String text = "$playerName $playerSurname";

    return Text(
      text,
      textAlign: isLeftOrientation ? TextAlign.start : TextAlign.end,
      style: TextStyle(
        color: fontColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
    );

  }

}

class _GoalItem extends StatelessWidget {

  final int goals;

  final double iconSize = ICON_SIZE;
  final double fontSize = 14;
  final Color fontColor = blueAgonisticaColor;
  final FontWeight fontWeight = FontWeight.normal;

  _GoalItem({
    this.goals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ICON_HORIZ_MARGIN),
      child: Stack(
        children: [
          goalsIcon(),
          goalsText(),
        ],
      ),
    );
  }

  Widget goalsIcon() {
    final double widthFactor = goals > 0 ? 0.8 : 1;
    final double size = widthFactor * iconSize;
    if(goals > 0) {
      return Container(
        width: size,
        height: size,
        child: SvgPicture.asset(
          'assets/images/010-football.svg', color: blueAgonisticaColor,),
      );
    } else {
      return SizedBox();
    }
  }

  Widget goalsText() {
    final double size = iconSize;
    if(goals > 1) {
      return Container(
        width: size,
        height: size,
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(top: size / 3, left: size / 3),
        child: Text(
          "$goals",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: fontColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ),
      );
    } else {
      return SizedBox();
    }
  }

}

class _SubstitutionItem extends StatelessWidget {

  final int substitution;

  final double iconSize = ICON_SIZE;

  _SubstitutionItem({
    this.substitution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ICON_HORIZ_MARGIN),
      child: arrowWidget(),
    );
  }

  Widget arrowWidget() {
    switch(substitution) {
      case MatchPlayerData.SUBSTITUTION_ENTERED: return enterSubstitutionArrow();
      case MatchPlayerData.SUBSTITUTION_EXITED: return exitSubstitutionArrow();
      default: return noneSubstitution();
    }
  }

  Widget exitSubstitutionArrow() {
    return Container(
      width: iconSize,
      height: iconSize,
      child: SvgPicture.asset(MatchPlayerData.getSubstitutionAsset(MatchPlayerData.SUBSTITUTION_EXITED))
    );
  }

  Widget enterSubstitutionArrow() {
    return Container(
        width: iconSize,
        height: iconSize,
        child: SvgPicture.asset(MatchPlayerData.getSubstitutionAsset(MatchPlayerData.SUBSTITUTION_ENTERED))
    );
  }

  Widget noneSubstitution() {
    return SizedBox();
  }

}

class _CardItem extends StatelessWidget {

  final int card;

  final double iconSize = ICON_SIZE;

  _CardItem({ this.card });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: ICON_HORIZ_MARGIN),
      child: selectCard(),
    );
  }

  Widget selectCard() {
    switch(card) {
      case MatchPlayerData.CARD_YELLOW: return yellowCardWidget(iconSize);
      case MatchPlayerData.CARD_RED: return redCardWidget(iconSize);
      case MatchPlayerData.CARD_DOUBLE_YELLOW: return doubleCardWidget(iconSize);
      default: return noneCardWidget();
    }
  }

  Widget yellowCardWidget(double size) {
    return cardWidget(MatchPlayerData.getCardAsset(MatchPlayerData.CARD_YELLOW), size);
  }

  Widget redCardWidget(double size) {
    return cardWidget(MatchPlayerData.getCardAsset(MatchPlayerData.CARD_RED), size);
  }

  Widget doubleCardWidget(double size) {
    return cardWidget(MatchPlayerData.getCardAsset(MatchPlayerData.CARD_DOUBLE_YELLOW), size);
  }

  Widget cardWidget(String assetName, double size) {
    return Container(
      width: size,
      height: size,
      child: SvgPicture.asset(assetName),
    );
  }

  Widget noneCardWidget() {
    return SizedBox();
  }

}