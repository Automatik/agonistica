import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class PlayerReview extends StatelessWidget{

  final String name, role;
  final DateTime birthDay;
  final double width, minHeight;
  final Function onTap, onSettingsTap;

  final double iconsSize = 20;
  final double topMargin = 10;
  final double bottomMargin = 10;

  PlayerReview({
    this.name,
    this.role,
    this.birthDay,
    this.width,
    this.minHeight = 50,
    this.onTap,
    this.onSettingsTap
  });


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        constraints: BoxConstraints(
          maxWidth: width,
          minHeight: minHeight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 12, right: 5, top: topMargin),
                  child: Icon(Icons.person, color: blueAgonisticaColor, size: iconsSize,),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: topMargin),
                    child: Text(
                      name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Container(
                    margin: EdgeInsets.only(left: 5, right: 12, top: topMargin),
                    child: Icon(Icons.more_vert, color: blueAgonisticaColor, size: iconsSize,)
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 12, top: topMargin, bottom: bottomMargin),
                    child: Text(
                      role,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 15, top: topMargin, bottom: bottomMargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(Icons.calendar_today, color: blueAgonisticaColor, size: iconsSize,),
                        SizedBox(width: 5,),
                        Text(
                          "${birthDay.day} " + Utils.monthToString(birthDay.month).substring(0, 4) + " ${birthDay.year}",
                          textAlign: TextAlign.end,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }



}