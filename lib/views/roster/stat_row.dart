import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

class StatRow extends StatefulWidget {

  final String statName;
  final int value;
  final bool isEditEnabled;
  final Function(int) onChange;
  final double width;

  StatRow({
    @required this.statName,
    @required this.value,
    @required this.isEditEnabled,
    @required this.onChange,
    @required this.width
  });

  @override
  State<StatefulWidget> createState() => _StatRowState();

}

class _StatRowState extends State<StatRow> {

  @override
  Widget build(BuildContext context) {
    double doubleValue = widget.value.toDouble();

    Widget element;
    if(widget.isEditEnabled) {
      element = Slider(
        min: SeasonPlayer.MIN_VALUE.toDouble(),
        max: SeasonPlayer.MAX_VALUE.toDouble(),
        divisions: SeasonPlayer.MAX_VALUE,
        label: widget.value.round().toString(),
        value: doubleValue,
        onChanged: (v) {
          widget.onChange(v.toInt());
          setState(() {
            doubleValue = v;
          });
        },
        activeColor: blueAgonisticaColor,
        inactiveColor: blueLightAgonisticaColor,
      );
    } else {
      element = circlesBar(widget.value, SeasonPlayer.MAX_VALUE, widget.width);
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.statName,
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
    double size = 0.7 * maxWidth / SeasonPlayer.MAX_VALUE;
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

}