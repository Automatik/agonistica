import 'package:agonistica/core/utils/date_utils.dart';
import 'package:flutter/material.dart';

class DateWidget extends StatelessWidget {

  final DateTime dateTime;
  final TextStyle textStyle;
  final MainAxisAlignment mainAxisAlignment;
  final Color iconColor;
  final double iconSize;

  DateWidget({
    @required this.dateTime,
    @required this.textStyle,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.iconColor = Colors.white,
    this.iconSize = 20,
  });

  @override
  Widget build(BuildContext context) {
    String dateText = "${dateTime.day} ${DateUtils.monthToString(dateTime.month).substring(0, 3)} ${dateTime.year}";
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      children: [
        Icon(Icons.calendar_today, color: iconColor, size: iconSize,),
        SizedBox(width: 5,),
        Text(
          dateText,
          textAlign: TextAlign.end,
          style: TextStyle(
            color: textStyle.color,
            fontSize: textStyle.fontSize,
            fontWeight: textStyle.fontWeight,
          ),
        ),
      ]
    );
  }

}
