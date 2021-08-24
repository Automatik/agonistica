import 'package:agonistica/core/arguments/categories_view_arguments.dart';
import 'package:agonistica/core/arguments/matches_view_arguments.dart';
import 'package:agonistica/core/arguments/roster_view_arguments.dart';
import 'package:agonistica/core/arguments/team_view_arguments.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:agonistica/views/home/home_view.dart';
import 'package:agonistica/views/matches/matches_view.dart';
import 'package:agonistica/views/roster/roster_view.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:agonistica/widgets/dialogs/tab_leaving_dialog.dart';
import 'package:flutter/material.dart';

class NavUtils {

  static Future<void> navToHomeView(BuildContext context) async {
    await Navigator.pushNamed(context, HomeView.routeName);
  }

  static Future<void> navToCategoriesView(BuildContext context, List<String> categoriesIds) async {
    await Navigator.pushNamed(
      context,
      CategoriesView.routeName,
      arguments: CategoriesViewArguments(categoriesIds),
    );
  }

  static Future<void> navToNewMatch(BuildContext context, String categoryId, String seasonId, String team1ImageFilename, String team2ImageFilename, Function(Match) onMatchDetailUpdate) async {
    bool isNewMatch = true;
    Match match = Match.empty(categoryId, seasonId, team1ImageFilename, team2ImageFilename);
    navToMatchesView(context, MatchesViewArguments(isNewMatch, match, onMatchDetailUpdate));
  }

  static Future<void> navToNewPlayer(BuildContext context, SeasonTeam seasonTeam, Category category, Function(SeasonPlayer) onPlayerDetailUpdate) async {
    bool isNewPlayer = true;
    SeasonPlayer seasonPlayer = SeasonPlayer.newPlayer(seasonTeam, category);
    navToRosterView(context, RosterViewArguments(isNewPlayer, seasonPlayer, onPlayerDetailUpdate));
  }

  static Future<void> navToMatchDetail(BuildContext context, Match match, Function(Match) onMatchDetailUpdate) async {
    bool isNewMatch = false;
    navToMatchesView(context, MatchesViewArguments(isNewMatch, match, onMatchDetailUpdate));
  }

  static Future<void> navToPlayerDetail(BuildContext context, SeasonPlayer seasonPlayer, Function(SeasonPlayer) onPlayerDetailUpdate) async {
    bool isNewPlayer = false;
    navToRosterView(context, RosterViewArguments(isNewPlayer, seasonPlayer, onPlayerDetailUpdate));
  }

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

  static void closeView(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// If the user tap on a BottomBar item and edit mode is enabled then ask
  /// through a dialog if he wants to leave.
  static Future<void> leaveBottomBarTab(BuildContext context, int currentTabIndex, bool isEditEnabled, int index1, int index2) async {
    if(isEditEnabled) {
      final dialog = TabLeavingDialog(
        onConfirm: () {
          NavUtils.closeView(context); //close dialog
          changeBottomBarItem(context, currentTabIndex, index1, index2);
        },
        onCancel: () => NavUtils.closeView(context), //close dialog
      );
      await dialog.showTabLeavingDialog(context);
      return;
    }
    changeBottomBarItem(context, currentTabIndex, index1, index2);
  }

  /// If the current index corresponds to the current tab (index1) then pop the
  /// view, otherwise change tab to index2
  static void changeBottomBarItem(BuildContext context, int currentTabIndex, int index1, int index2) {
    if(currentTabIndex == index1) {
      // This is possible only if we come to this Tab from TeamView
      closeView(context);
    } else {
      Navigator.of(context).pushNamed(
          TeamView.routeName,
          arguments: TeamViewArguments(index2),
      );
    }
  }

}