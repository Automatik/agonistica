import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/NotesViewArguments.dart';
import 'package:agonistica/core/arguments/TeamViewArguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:agonistica/widgets/popups/player_matches_view_popup_menu.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/views/notes/notes_view.dart';
import 'package:agonistica/views/player_matches/match_notes_object.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class PlayerMatchesViewModel extends BaseViewModel {

  static const int SHOW_ADD_ACTION = 0;
  static const int HIDE_ADD_ACTION = 1;

  static Logger _logger = getLogger('PlayerMatchesViewModel');

  final _appStateService = locator<AppStateService>();
  final _databaseService = locator<DatabaseService>();

  final String seasonPlayerId;
  final String playerName;
  final String playerSurname;
  final int addAction;

  SeasonPlayer seasonPlayer;
  List<MatchNotesObject> objects;

  PlayerMatchesViewModel(this.seasonPlayerId, this.playerName, this.playerSurname, this.addAction){
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
      objects = createObjects(matches, notes);

    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  List<MatchNotesObject> createObjects(List<Match> matches, List<PlayerMatchNotes> notes) {
    List<MatchNotesObject> objs = [];
    matches.forEach((match) {
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
      objs.add(object);
    });
    return objs;
  }

  void _onPlayerMatchesDetailUpdate(Match match) {
    _logger.d("PlayerMatchesModel/onMatchDetailUpdate");
    List<String> matchesIds = objects.map((e) => e.match.id);
    if(!matchesIds.contains(match.id)) {
      List<MatchNotesObject> newObjects = createObjects([match], []);
      objects.addAll(newObjects);
    }
    _updateView();
  }

  void _updateView() {
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
      arguments: NotesViewArguments(object.notes, object.match, playerName, playerSurname),
    );
  }

  Future<void> addNewMatch(BuildContext context) async {
    String categoryId = _appStateService.selectedCategory.id;
    String seasonId = _appStateService.selectedSeason.id;
    NavUtils.navToNewMatch(context, categoryId, seasonId, _onPlayerMatchesDetailUpdate);
  }

  Future<void> deleteMatch(MatchNotesObject object) async {
    int index = objects.indexWhere((obj) => obj.match.id == object.match.id);
    if(index == -1) {
      _logger.w("Object corresponding to match ${object.match.id} not found in list");
      return;
    }
    objects.removeAt(index);
    bool notesExist = await _databaseService.playerNotesService.itemExists(object.notes.id);
    if(notesExist) {
      await _databaseService.playerNotesService.deleteItem(object.notes.id);
    }
    await _databaseService.matchService.deleteItem(object.match.id);
    _updateView();
  }

  List<int> getPopupMenuItemValues() {
    List<int> itemValues = [];
    itemValues.add(PlayerMatchesViewPopupMenu.VIEW_MATCH_CARD);
    itemValues.add(PlayerMatchesViewPopupMenu.VIEW_NOTES_CARD);
    if(addAction == SHOW_ADD_ACTION) {
      // only when coming from PlayersView we let delete a match in this view
      itemValues.add(PlayerMatchesViewPopupMenu.DELETE_MATCH_CARD);
    }
    return itemValues;
  }

  Future<void> onPopupMenuItemSelected(BuildContext context, int value, MatchNotesObject object) async {
    switch(value) {
      case PlayerMatchesViewPopupMenu.VIEW_MATCH_CARD: NavUtils.navToMatchDetail(context, object.match, _onPlayerMatchesDetailUpdate); break;
      case PlayerMatchesViewPopupMenu.VIEW_NOTES_CARD: onPlayerMatchNotesClick(context, object); break;
      case PlayerMatchesViewPopupMenu.DELETE_MATCH_CARD: deleteMatch(object); break;
    }
  }

  String getAppBarTitle() {
    return "Partite di $playerName $playerSurname";
  }

  bool showAddAction() {
    return addAction == SHOW_ADD_ACTION;
  }

}