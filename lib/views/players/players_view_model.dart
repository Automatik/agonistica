// @dart=2.9

import 'dart:collection';

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/arguments/roster_view_arguments.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/models/player.dart';
import 'package:agonistica/core/models/season_player.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/utils/nav_utils.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:stacked/stacked.dart';

class PlayersViewModel extends BaseViewModel {

  static Logger _logger = getLogger('PlayersViewModel');

  final _databaseService = locator<DatabaseService>();
  final _appStateService = locator<AppStateService>();

  SplayTreeSet<SeasonPlayer> _sortedSeasonPlayers;

  PlayersViewModel() {
    _sortedSeasonPlayers = SplayTreeSet((sp1, sp2) => SeasonPlayer.compare(sp1, sp2));
    loadItems();
  }

  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    FollowedPlayers followedPlayers = await _databaseService.followedPlayersService.getFollowedPlayers();

    String categoryId = _appStateService.selectedCategory.id;
    String seasonId = _appStateService.selectedSeason.id;
    List<Player> players = await _databaseService.playerService.getItemsByIds(followedPlayers.playersIds);
    List<SeasonPlayer> seasonPlayers = await _databaseService.seasonPlayerService
        .getSeasonPlayersWithCategoryAndSeasonFromPlayers(categoryId, seasonId, players);
    seasonPlayers = await _databaseService.seasonPlayerService.completeSeasonPlayersWithMissingInfo(seasonPlayers);

    _sortedSeasonPlayers.addAll(seasonPlayers);

    //Let other views to render again
    setBusy(false);
    notifyListeners();
  }

  void _updateView() {
    notifyListeners();
  }

  String getWidgetTitle() {
    return _appStateService.selectedCategory.name;
  }

  int getSeasonPlayersSize() {
    return _sortedSeasonPlayers.length;
  }

  SeasonPlayer getSeasonPlayers(int index) {
    return _sortedSeasonPlayers.elementAt(index);
  }

  /// Use this callback to update the players listView. When this method is
  /// executed, the player has been already saved
  void _onPlayerDetailUpdate(SeasonPlayer seasonPlayer) {
    if(_sortedSeasonPlayers == null) {
      _logger.d("players list is null");
      return;
    }

    // check if player's id is already in players list
    // meaning the player is updated
    SeasonPlayer player = _sortedSeasonPlayers.firstWhere((sp) => sp.id == seasonPlayer.id, orElse: () => null);
    if(player != null) {
      // check if the player's team or category has changed
      if(seasonPlayer.seasonTeamId != _appStateService.selectedTeam.id || seasonPlayer.categoryId != _appStateService.selectedCategory.id) {
        // remove the player from the players list
        _sortedSeasonPlayers.removeWhere((sp) => sp.id == seasonPlayer.id);
      } else {
        // otherwise update the players list
        _sortedSeasonPlayers.removeWhere((sp) => sp.id == seasonPlayer.id);
        _sortedSeasonPlayers.add(seasonPlayer);
      }
      _logger.d("player updated in list");
    } else {
      // otherwise it's a new player
      _sortedSeasonPlayers.add(seasonPlayer);
      _logger.d("new player added to list");
    }

    _updateView();
  }

  Future<void> openPlayerDetail(BuildContext context, int index) async {
    if(_sortedSeasonPlayers == null || _sortedSeasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = _sortedSeasonPlayers.elementAt(index);
    NavUtils.navToPlayerDetail(context, seasonPlayer, _onPlayerDetailUpdate);
  }

  Future<void> addNewPlayer(BuildContext context) async {
    SeasonTeam seasonTeam = await _databaseService.createNewSeasonTeamAndTeam(Team.EMPTY_TEAM_NAME, _appStateService.selectedSeason.id);
    Category category = _appStateService.selectedCategory;
    NavUtils.navToNewPlayer(context, seasonTeam, category, _onPlayerDetailUpdate);
  }

  Future<void> deletePlayer(int index) async {
    if(_sortedSeasonPlayers == null || _sortedSeasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = _sortedSeasonPlayers.elementAt(index);
    _sortedSeasonPlayers.removeWhere((element) => element.id == seasonPlayer.id);
    await _databaseService.seasonPlayerService.deleteItem(seasonPlayer.id);
    _updateView();
  }

}