// @dart=2.9

import 'package:flutter/material.dart';

class TitleTextStyle extends TextStyle {

  final BuildContext context;

  TitleTextStyle({
    @required this.context,
  }) : super(fontSize: 32, color: Colors.white);

  TextStyle compose() {
    var themeTextStyle = Theme.of(context).textTheme.bodyText2;
    return themeTextStyle.merge(this);
  }

}