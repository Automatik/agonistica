

import 'package:flutter/material.dart';

class MySnackBar {

  static Future<void> showSnackBar(BuildContext context, String text, {duration = 2500}) async {
    final snackBar = SnackBar(
      content: Text(text,),
      duration: Duration(milliseconds: duration),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

}