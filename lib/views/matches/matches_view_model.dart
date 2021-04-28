import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/arguments/notes_view_arguments.dart';
import 'package:agonistica/core/arguments/roster_view_arguments.dart';
import 'package:agonistica/core/guards/preconditions.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/match_player_data.dart';
import 'package:agonistica/core/models/player_match_notes.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/views/notes/notes_view.dart';
import 'package:agonistica/widgets/scaffolds/tab_scaffold_widget.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class MatchesViewModel extends BaseViewModel {

  static Logger _logger = getLogger('MatchesViewModel');

  final bool isNewMatch;
  Match match;
  final Function(Match) onMatchDetailUpdate;

  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  List<SeasonTeam> seasonTeams;

  Map<String, List<SeasonPlayer>> teamsPlayersMap;

  MatchesViewModel(this.isNewMatch, this.match, this.onMatchDetailUpdate){
    seasonTeams = [];
    teamsPlayersMap = Map();
    loadItems();
  }
  
  // Add ViewModel specific code here
  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    seasonTeams = await _databaseService.seasonTeamService.getSeasonTeamsWithSeason(match.seasonId);
    for(SeasonTeam seasonTeam in seasonTeams) {
      seasonTeam = await _databaseService.seasonTeamService.completeSeasonTeamWithMissingInfo(seasonTeam);
    }

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  List<SeasonTeam> suggestTeamsByPattern(String pattern) {
    if(pattern == null || pattern.isEmpty)
      return seasonTeams;
    return seasonTeams.where((st) => st.getTeamName().startsWith(pattern));
  }

  Future<void> loadTeamPlayers(String seasonTeamId) async {
    String categoryId = _appStateService.selectedCategory.id;
    List<SeasonPlayer> teamSeasonPlayers = await _databaseService.seasonPlayerService.getSeasonPlayersByTeamAndCategory(seasonTeamId, categoryId);
    teamSeasonPlayers = await _databaseService.seasonPlayerService.completeSeasonPlayersWithMissingInfo(teamSeasonPlayers);
    if(!teamsPlayersMap.containsKey(seasonTeamId))
      teamsPlayersMap.putIfAbsent(seasonTeamId, () => teamSeasonPlayers);
    else
      teamsPlayersMap.update(seasonTeamId, (_) => teamSeasonPlayers);
  }

  List<SeasonPlayer> suggestPlayersByPattern(String namePattern, String surnamePattern, String seasonTeamId) {
    List<SeasonPlayer> teamSeasonPlayers = teamsPlayersMap[seasonTeamId];
    if(teamSeasonPlayers == null)
      return [];
    if(namePattern.isEmpty) {
      return teamSeasonPlayers.where((sp) => sp.getPlayerSurname().startsWith(surnamePattern)).toList();
    }
    if(surnamePattern.isEmpty) {
      return teamSeasonPlayers.where((sp) => sp.getPlayerName().startsWith(namePattern)).toList();
    }
    return teamSeasonPlayers.where((sp) {
      return sp.getPlayerName().startsWith(namePattern) && sp.getPlayerSurname().startsWith(surnamePattern);
    }).toList();
  }

  Future<void> onBottomBarItemChanged(BuildContext context, int index, bool isEditEnabled) async {
    await NavUtils.leaveBottomBarTab(context, index, isEditEnabled,
        TabScaffoldWidget.MATCHES_VIEW_INDEX, TabScaffoldWidget.ROSTER_VIEW_INDEX);
  }

  Future<void> onMatchSave(BuildContext context, Match newMatch) async {
    await _databaseService.matchService.saveItem(newMatch);

    onMatchDetailUpdate(newMatch);

    // return to TeamView
    //Navigator.of(context).pop();

    match = Match.clone(newMatch);
  }

  Future<void> viewPlayerCard(BuildContext context, String seasonPlayerId) async {
    Preconditions.requireArgumentStringNotNull(seasonPlayerId);

    SeasonPlayer seasonPlayer = await _databaseService.seasonPlayerService.getItemById(seasonPlayerId);
    seasonPlayer = await _databaseService.seasonPlayerService.completeSeasonPlayerWithMissingInfo(seasonPlayer);
    bool playerExists = seasonPlayer != null;
    if(playerExists) {
      bool isNewPlayer = false;
      NavUtils.navToRosterView(context, RosterViewArguments(isNewPlayer, seasonPlayer, null));
    }
  }

  Future<void> viewNotesCard(BuildContext context, Match match, MatchPlayerData matchPlayerData) async {
    PlayerMatchNotes notes = await _databaseService.playerNotesService.getPlayerMatchNotesByPlayer(matchPlayerData.seasonPlayerId, match.id);
    if(notes == null) {
      notes = PlayerMatchNotes(match.id, matchPlayerData.seasonPlayerId);
    }
    Navigator.of(context).pushNamed(
      NotesView.routeName,
      arguments: NotesViewArguments(notes, match, matchPlayerData.name, matchPlayerData.surname),
    );
  }

  String getAppBarTitle() {
    return isNewMatch ? "Nuova Partita" : _appStateService.selectedTeam.name;
  }

}