import 'package:agonistica/core/arguments/MatchesViewArguments.dart';
import 'package:agonistica/core/arguments/RosterViewArguments.dart';
import 'package:agonistica/views/matches/matches_view.dart';
import 'package:agonistica/views/roster/roster_view.dart';
import 'package:flutter/material.dart';

class NavUtils {

  static Future<void> navToRosterView(BuildContext context, RosterViewArguments args) async {
    await Navigator.pushNamed(
      context,
      RosterView.routeName,
      arguments: args,
    );
  }

  static Future<void> navToMatchesView(BuildContext context, MatchesViewArguments args) async {
    await Navigator.pushNamed(
      context,
      MatchesView.routeName,
      arguments: args,
    );
  }

}