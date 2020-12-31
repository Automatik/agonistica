import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const double ICON_SIZE = 20;
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: playerData(),
        ),
      ),
    );
  }

  List<Widget> playerData() {
    List<Widget> widgets = [
      Expanded(
        child: playerName(),
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: widget.isLeftOrientation ? MainAxisAlignment.end : MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: playerItems(),
        ),
      ),
    ];
    return reverseListBasedOnOrientation(widgets, widget.isLeftOrientation);
  }

  Widget playerName() {
    return _PlayerItemName(
      playerName: widget.matchPlayer.name,
      playerSurname: widget.matchPlayer.surname,
      isLeftOrientation: widget.isLeftOrientation,
    );
  }

  List<Widget> playerItems() {
    List<Widget> widgets = [];
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
    return reverseListBasedOnOrientation(widgets, widget.isLeftOrientation);
  }

  static List<Widget> reverseListBasedOnOrientation(List<Widget> widgets, bool isLeftOrientation) {
    if(isLeftOrientation)
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
    // return Container(
    //   width: iconSize,
    //   height: iconSize,
    //   margin: const EdgeInsets.symmetric(horizontal: ICON_HORIZ_MARGIN),
    //   child: Stack(
    //     children: [
    //       goalsIcon(),
    //       goalsText(),
    //     ],
    //   ),
    // );
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
    final double widthFactor = goals > 0 ? 0.9 : 1;
    final double size = widthFactor * iconSize;
    return Container(
      width: size,
      height: size,
      child: SvgPicture.asset('assets/images/010-football.svg', color: blueAgonisticaColor,),
    );
  }

  Widget goalsText() {
    final double size = iconSize;
    if(goals > 0) {
      return Align(
        alignment: Alignment.bottomRight,
        child: Container(
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
    return cardWidget(yellowColorLight, yellowColorDark, size);
  }

  Widget redCardWidget(double size) {
    return cardWidget(redColorLight, redColorDark, size);
  }

  Widget doubleCardWidget(double size) {

    final double factor = 0.8;

    return Container(
      width: size,
      height: size,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: yellowCardWidget(factor * size)
          ),
          Align(
            alignment: Alignment.bottomRight,
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: (widthCardFactor * size) / 2,
            height: size,
            color: leftColor,
          ),
          Container(
            width: (widthCardFactor * size) / 2,
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