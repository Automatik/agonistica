import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/arguments/RosterViewArguments.dart';
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

  List<SeasonPlayer> seasonPlayers;

  PlayersViewModel() {
    seasonPlayers = [];
    loadItems();
  }

  Future<void> loadItems() async {
    setBusy(true);
    //Write your models loading codes here

    // TODO replace with getting the user's followedPlayers
    // FollowedPlayers followedPlayers = _databaseService.followedPlayersService.getItemById();
    List<FollowedPlayers> followedPlayersList = await _databaseService.followedPlayersService.getAllItems();
    if(followedPlayersList.isEmpty) {
      // Do this because of missing initializer (remove when implementing user)
      FollowedPlayers followedPlayers = FollowedPlayers.empty();
      await _databaseService.followedPlayersService.saveItem(followedPlayers);
      followedPlayersList.add(followedPlayers);
    }
    FollowedPlayers followedPlayers = followedPlayersList[0];

    String categoryId = _appStateService.selectedCategory.id;
    String seasonId = _appStateService.selectedSeason.id;
    List<Player> players = await _databaseService.playerService.getItemsByIds(followedPlayers.playersIds);
    seasonPlayers = await _databaseService.seasonPlayerService
        .getSeasonPlayersWithCategoryAndSeasonFromPlayers(categoryId, seasonId, players);
    seasonPlayers = await _databaseService.seasonPlayerService.completeSeasonPlayersWithMissingInfo(seasonPlayers);

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

  /// Use this callback to update the players listView. When this method is
  /// executed, the player has been already saved
  void _onPlayerDetailUpdate(SeasonPlayer seasonPlayer) {
    if(seasonPlayers == null) {
      _logger.d("players list is null");
      return;
    }

    // check if player's id is already in players list
    // meaning the player is updated
    int index = seasonPlayers.indexWhere((p) => p.id == seasonPlayer.id);
    if(index != -1) {

      // check if the player's team or category has changed
      if(seasonPlayer.seasonTeamId != _appStateService.selectedTeam.id || seasonPlayer.categoryId != _appStateService.selectedCategory.id) {
        // remove the player from the players list
        seasonPlayers.removeAt(index);
      } else {
        // otherwise update the players list
        seasonPlayers[index] = seasonPlayer;
      }
      _logger.d("player updated in list");
    } else {
      // otherwise it's a new player
      seasonPlayers.add(seasonPlayer);
      _logger.d("new player added to list");
    }
    _updateView();
  }

  Future<void> openPlayerDetail(BuildContext context, int index) async {
    if(seasonPlayers == null || seasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = seasonPlayers[index];
    NavUtils.navToPlayerDetail(context, seasonPlayer, _onPlayerDetailUpdate);
  }

  Future<void> addNewPlayer(BuildContext context) async {
    SeasonTeam seasonTeam = SeasonTeam.newTeam(Team.EMPTY_TEAM_NAME, _appStateService.selectedSeason.id);
    Category category = _appStateService.selectedCategory;
    NavUtils.navToNewPlayer(context, seasonTeam, category, _onPlayerDetailUpdate);
  }

  Future<void> deletePlayer(int index) async {
    if(seasonPlayers == null || seasonPlayers.isEmpty) {
      _logger.d("Players is null or empty when calling deleteMatch");
      return;
    }
    SeasonPlayer seasonPlayer = seasonPlayers.removeAt(index);
    await _databaseService.seasonPlayerService.deleteItem(seasonPlayer.id);
    _updateView();
  }

}