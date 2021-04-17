import 'package:agonistica/core/arguments/NotesViewArguments.dart';
import 'package:agonistica/core/arguments/TeamViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/notes/notes_view.dart';
import 'package:agonistica/views/player_matches/match_notes_object.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PlayerMatchesViewModel extends BaseViewModel {

  final _databaseService = locator<DatabaseService>();

  final String seasonPlayerId;
  final String playerName;

  SeasonPlayer seasonPlayer;
  List<MatchNotesObject> objects;

  PlayerMatchesViewModel(this.seasonPlayerId, this.playerName){
    objects = [];
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    // Get the player's instance
    seasonPlayer = await _databaseService.seasonPlayerService.getItemById(seasonPlayerId);

    if(seasonPlayer != null && seasonPlayer.matchesIds != null) {

      // Get matches in which the player has played
      List<Match> matches = await _databaseService.matchService.getItemsByIds(seasonPlayer.matchesIds);

      matches = await _databaseService.matchService.completeMatchesWithMissingInfo(matches);

      // Get Player's match notes
      final notes = await _databaseService.playerNotesService.getPlayerNotesByPlayer(seasonPlayer);

      // Combine matches with notes in the objects list
      objects = [];
      for(Match match in matches) {

        MatchNotesObject object;

        int index = notes.indexWhere((n) => n.matchId == match.id);
        if(index != -1) {
          // a note exists for this match
          PlayerMatchNotes note = notes.removeAt(index);
          object = MatchNotesObject(match, note);
        } else {
          // a note does not exist for this match
          PlayerMatchNotes note = PlayerMatchNotes(match.id, seasonPlayerId);
          object = MatchNotesObject(match, note);
        }
        objects.add(object);
      }

    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

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

  Future<void> onPlayerMatchNotesClick(BuildContext context, MatchNotesObject object) async {
    Navigator.of(context).pushNamed(
      NotesView.routeName,
      arguments: NotesViewArguments(object.notes, object.match, playerName),
    );
  }

  String getAppBarTitle() {
    return "Partite di $playerName";
  }

}