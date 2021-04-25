import 'package:agonistica/core/arguments/TeamViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class NotesViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  final PlayerMatchNotes notes;
  final Match match;
  final String playerName;
  final String playerSurname;

  NotesViewModel(this.notes, this.match, this.playerName, this.playerSurname);

  void onBottomBarItemChanged(BuildContext context, int index) {

    if(index == TabScaffoldWidget.ROSTER_VIEW_INDEX) {
      // This is possible only if we come to this RosterView only from TeamView
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamed(
          TeamView.routeName,
          arguments: TeamViewArguments(TabScaffoldWidget.MATCHES_VIEW_INDEX)
      );
    }
  }

  Future<void> onNotesSave(String text) async {
    notes.notes = text;
    await _databaseService.playerNotesService.saveItem(notes);
  }

  String getAppBarTitle() {
    return "Note di $playerName $playerSurname";
  }

}