import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double ICON_SIZE = 16;
const double ICON_HORIZ_MARGIN = 2.5;

class PlayerItem extends StatefulWidget {

  final MatchPlayerData matchPlayer;
  final bool isLeftOrientation;

  PlayerItem({
    this.matchPlayer,
    this.isLeftOrientation,
  });

  @override
  State<StatefulWidget> createState() => _PlayerItemState();

}

class _PlayerItemState extends State<PlayerItem> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: blueAgonisticaColor,
            width: 1,
            style: BorderStyle.solid,
          )
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: widget.isLeftOrientation ? MainAxisAlignment.start : MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: playerItems(),
        ),
      ),
    );
  }

  List<Widget> playerItems() {
    List<Widget> widgets = [];
    widgets.add(
      _PlayerItemName(
        playerName: widget.matchPlayer.name,
        playerSurname: widget.matchPlayer.surname,
        isLeftOrientation: widget.isLeftOrientation,
      ),
    );
    widgets.add(
      _SubstitutionItem(
        substitution: widget.matchPlayer.substitution,
      ),
    );
    widgets.add(
      _CardItem(
        card: widget.matchPlayer.card,
      ),
    );
    widgets.add(
      _GoalItem(
          goals: widget.matchPlayer.numGoals),
    );
    if(widget.isLeftOrientation)
      return widgets;
    else
      return widgets.reversed.toList();
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

    return Flexible(
      child: Text(
        text,
        textAlign: isLeftOrientation ? TextAlign.start : TextAlign.end,
        style: TextStyle(
          color: fontColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
      ),
    );

  }

}

class _GoalItem extends StatelessWidget {

  final int goals;

  final double iconSize = ICON_SIZE;
  final double fontSize = 16;
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
          Container(
            width: iconSize,
            height: iconSize,
            child: SvgPicture.asset('assets/images/010-football.svg'),
          ),
          goalsText(),
        ],
      ),
    );
  }

  Widget goalsText() {
    if(goals > 0) {
      return Container(
        alignment: Alignment.bottomRight,
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
      child: SvgPicture.asset('assets/images/down-arrow.svg', color: Colors.red,)
    );
  }

  Widget enterSubstitutionArrow() {
    return Container(
        width: iconSize,
        height: iconSize,
        child: SvgPicture.asset('assets/images/up-arrow.svg', color: Colors.green,)
    );
  }

  Widget noneSubstitution() {
    return SizedBox();
  }

}

class _CardItem extends StatelessWidget {

  final int card;

  final double iconSize = ICON_SIZE;
  final double widthCardFactor = 0.7;

  final Color yellowColorLight = Color.fromRGBO(255, 250, 23, 1);
  final Color yellowColorDark = Color.fromRGBO(255, 209, 0, 1);
  final Color redColorLight = Color.fromRGBO(255, 55, 97, 1);
  final Color redColorDark = Color.fromRGBO(221, 0, 57, 1);

  _CardItem({ this.card });

  @override
  Widget build(BuildContext context) {
    switch(card) {
      case MatchPlayerData.CARD_YELLOW: return yellowCardWidget(iconSize);
      case MatchPlayerData.CARD_RED: return redCardWidget(iconSize);
      case MatchPlayerData.CARD_DOUBLE_YELLOW: return doubleCardWidget(iconSize);
      default: return noneCardWidget();
    }
  }

  Widget yellowCardWidget(double size) {
    return cardWidget(yellowColorLight, yellowColorDark, size);
  }

  Widget redCardWidget(double size) {
    return cardWidget(redColorLight, redColorDark, size);
  }

  Widget doubleCardWidget(double size) {

    final double factor = 0.66;

    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: ICON_HORIZ_MARGIN),
      child: Stack(
        children: [
          yellowCardWidget(factor * size),
          Align(
            alignment: Alignment.centerRight,
            child: redCardWidget(factor * size),
          )
        ],
      ),
    );
  }

  Widget cardWidget(Color leftColor, Color rightColor, double size) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: ICON_HORIZ_MARGIN),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: widthCardFactor * size,
            height: size,
            color: leftColor,
          ),
          Container(
            width: widthCardFactor * size,
            height: size,
            color: rightColor,
          ),
        ],
      ),
    );
  }

  Widget noneCardWidget() {
    return SizedBox();
  }

}