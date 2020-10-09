import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class Utils {

  static PlatformAppBar getPlatformAppBar(String title) {
    return PlatformAppBar(
        backgroundColor: appBarBackgroundColor,
        title: Text(
          title,
          style: TextStyle(
            color: blueAgonisticaColor,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          leading: Icon(Icons.menu,color: blueAgonisticaColor,),
        )
    );
  }

  static PlatformAppBar getPlatformAppBarWithAddAction(String title, Function onActionAddPressed) {
    return PlatformAppBar(
        backgroundColor: appBarBackgroundColor,
        title: Text(
          title,
          style: TextStyle(
            color: blueAgonisticaColor,
          ),
        ),
        material: (_, __) => MaterialAppBarData(
          leading: Icon(Icons.menu,color: blueAgonisticaColor,),
          actions: [
            GestureDetector(
              onTap: onActionAddPressed,
              child: Icon(
                Icons.add,
                color: blueAgonisticaColor,
              ),
            )
          ]
        ),
    );
  }

  static String monthToString(int month) {
    if(month < 1 || month > 12)
      return "";
    switch (month) {
      case 1 : return "Gennaio";
      case 2: return "Febbraio";
      case 3: return "Marzo";
      case 4: return "Aprile";
      case 5: return "Maggio";
      case 6: return "Giugno";
      case 7: return "Luglio";
      case 8: return "Agosto";
      case 9: return "Settembre";
      case 10: return "Ottobre";
      case 11: return "Novembre";
      case 12: return "Dicembre";
    }
  }

  /// Use this to clone DateTime
  static DateTime fromDateTime(
      DateTime src, {
        int year: null,
        int month : null,
        int day : null,
        int hour : null,
        int minute : null,
        int second : null,
        int millisecond : null}) {
    return new DateTime(
        year == null ? src.year : year,
        month == null ? src.month : month,
        day == null ? src.day : day,
        hour == null ? src.hour : hour,
        minute == null ? src.minute : minute,
        second == null ? src.second : second,
        millisecond == null ? src.millisecond : millisecond
    );
  }

}