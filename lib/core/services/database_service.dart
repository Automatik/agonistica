import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/MatchPlayerData.dart';
import 'package:agonistica/core/models/Player.dart';
import 'package:agonistica/core/models/PlayerMatchNotes.dart';
import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/repositories/player_notes_repository.dart';
import 'file:///C:/Users/Emil/Google%20Drive/FlutterProjects/agonistica/lib/core/repositories/category_repository.dart';
import 'file:///C:/Users/Emil/Google%20Drive/FlutterProjects/agonistica/lib/core/repositories/match_repository.dart';
import 'file:///C:/Users/Emil/Google%20Drive/FlutterProjects/agonistica/lib/core/repositories/player_repository.dart';
import 'file:///C:/Users/Emil/Google%20Drive/FlutterProjects/agonistica/lib/core/repositories/team_repository.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {

  static const String firebaseUsersChild = "users";
  static const String firebasePermissionsChild = "permissions";
  static const String firebaseTeamsChild = "teams";
  static const String firebaseCategoriesChild = "categories";
  static const String firebaseMatchesChild = "matches";
  static const String firebasePlayersChild = "players";
  static const String firebasePlayersNotesChild = "playersNotes";

  final DatabaseReference _databaseReference = FirebaseDatabase(databaseURL: "https://agonistica-67769.firebaseio.com/").reference();

  static Logger _logger = getLogger('DatabaseService');

  TeamRepository _teamRepository;
  CategoryRepository _categoryRepository;
  MatchRepository _matchRepository;
  PlayerRepository _playerRepository;
  PlayerNotesRepository _playerNotesRepository;


  Team mainTeam;
  List<Team> mainTeams;
  List<Category> mainCategories;

  Team selectedTeam;
  Category selectedCategory;

  DatabaseService() {
    _teamRepository = TeamRepository(_databaseReference);
    _categoryRepository = CategoryRepository(_databaseReference);
    _matchRepository = MatchRepository(_databaseReference);
    _playerRepository = PlayerRepository(_databaseReference);
    _playerNotesRepository = PlayerNotesRepository(_databaseReference);
  }

  Future<void> initialize() async {

    // Initialize database if needed with requested teams and categories
    final sharedPref = await SharedPreferences.getInstance();
    bool areTeamsAndCategoriesRequestedStored = sharedPref.getBool(areTeamsAndCategoriesRequestedStoredKey) ?? false;
    if(!areTeamsAndCategoriesRequestedStored) {
      await _initializeRequestedTeamsAndCategories(sharedPref);
      sharedPref.setBool(areTeamsAndCategoriesRequestedStoredKey, true);
    }

  }

  // GET TEAM

  Future<Team> getTeamById(String teamId) async {
    return await _teamRepository.getTeamById(teamId);
  }

  /// Download all teams without the other requested teams (merateTeam and other)
  Future<List<Team>> getTeamsWithoutOtherRequestedTeams() async {
    final sharedPref = await SharedPreferences.getInstance();
    List<String> requestedTeamsIds = sharedPref.getStringList(requestedTeamsIdsKey);
    return await _teamRepository.getTeamsWithoutIds(requestedTeamsIds);
  }

  /// Get List of the requested Teams
  Future<List<Team>> getMainTeams() async {
    final sharedPref = await SharedPreferences.getInstance();
    List<String> teamsIds = sharedPref.getStringList(requestedTeamsIdsKey);
    mainTeams = await _teamRepository.getTeamsByIds(teamsIds);
    return mainTeams;
  }

  /// Get List of the requested categories of the main team (Merate)
  Future<List<Category>> getMainCategories() async {
    // main categories from Merate Team
    final sharedPref = await SharedPreferences.getInstance();
    List<String> teamsIds = sharedPref.getStringList(requestedTeamsIdsKey);

    // Find Merate Team
    Team merateTeam = await _teamRepository.getTeamByNameFromIds(mainRequestedTeam, teamsIds);
    if(merateTeam != null)
      mainTeam = merateTeam;
    else
      return List();

    mainCategories = await _categoryRepository.getCategoriesByIds(merateTeam.categoriesIds);
    return mainCategories;
  }

  // GET CATEGORY

  Future<Category> getCategoryById(String categoryId) async {
    return await _categoryRepository.getCategoryById(categoryId);
  }

  /// Get the team's categories
  Future<List<Category>> getTeamCategories(String teamId) async {
    Team team = await _teamRepository.getTeamById(teamId);
    if(team == null || team.categoriesIds == null || team.categoriesIds.isEmpty)
      return [];
    return await _categoryRepository.getCategoriesByIds(team.categoriesIds);
  }

  // GET MATCH

  Future<List<Match>> getMatchesByIds(List<String> matchesIds) async {
    return await _matchRepository.getMatchesByIds(matchesIds);
  }

  /// Download all the matches of a team by filtering for the given category
  Future<List<Match>> getTeamMatchesByCategory(Team team, Category category) async {
    if(team == null || team.categoriesIds == null || team.categoriesIds.isEmpty ||
        team.matchesIds == null || team.matchesIds.isEmpty || category == null)
      return Future.value(List<Match>());
    List<Match> matches = await _matchRepository.getMatchesByIds(team.matchesIds);
    matches.removeWhere((match) => match.categoryId != category.id);
    return matches;
  }

  /// Download missing info for a given list of matches. For instance download the teams' names
  /// present in the matches list
  Future<List<Match>> completeMatchesWithMissingInfo(List<Match> matches) async {
    List<Match> newMatches = [];
    for(Match match in matches) {
      // Get teams' name
      Team tempTeam = await _teamRepository.getTeamById(match.team1Id);
      match.team1Name = tempTeam?.name;
      tempTeam = await _teamRepository.getTeamById(match.team2Id);
      match.team2Name = tempTeam?.name;
      newMatches.add(match);
    }
    return newMatches;
  }

  // GET PLAYER

  Future<Player> getPlayerById(String playerId) async {
    return await _playerRepository.getPlayerById(playerId);
  }

  /// Download players of the given team and category
  Future<List<Player>> getPlayersByTeamAndCategory(String teamId, String categoryId) async {
    Team team = await _teamRepository.getTeamById(teamId);
    if(team == null || team.playersIds == null || team.playersIds.isEmpty)
      return Future.value(List<Player>());
    List<Player> players = await _playerRepository.getPlayersByIds(team.playersIds);
    players.removeWhere((player) => player.categoryId != categoryId);
    return players;
  }

  // GET PLAYER MATCH NOTES

  Future<PlayerMatchNotes> getPlayerMatchNotesById(String playerMatchNotesId) async {
    return await _playerNotesRepository.getPlayerNotesById(playerMatchNotesId);
  }

  /// Download the player's notes
  Future<List<PlayerMatchNotes>> getPlayerNotesByPlayer(Player player) async {
    if(player == null || player.playerMatchNotesIds == null || player.playerMatchNotesIds.isEmpty)
      return Future.value(List<PlayerMatchNotes>());
    List<PlayerMatchNotes> playerMatchNotes = await _playerNotesRepository.getPlayersNotesByIds(player.playerMatchNotesIds);
    return playerMatchNotes;
  }

  // SET TEAM

  /// Upload Team data (update)
  Future<void> updateTeamFromMatch(Match match, Team team, List<String> matchPlayersIds) async {
    Team copy = await _teamRepository.getTeamById(team.id);
    if(copy != null) {
      team = copy;
    }
    // update the categories in which the team appears
    if(team.categoriesIds == null)
      team.categoriesIds = [];
    if(!team.categoriesIds.contains(match.categoryId))
      team.categoriesIds.add(match.categoryId);
    // update the matches in which the team plays
    if(team.matchesIds == null)
      team.matchesIds = [];
    if(!team.matchesIds.contains(match.id))
      team.matchesIds.add(match.id);
    // update the team's players
    if(team.playersIds == null)
      team.playersIds = [];
    for(String playerId in matchPlayersIds) {
      if(!team.playersIds.contains(playerId))
        team.playersIds.add(playerId);
    }

    _teamRepository.saveTeam(team);
  }

  // SET CATEGORY

  Future<void> saveCategory(Category category) async {
    // Not tested and not thought about requirements and consequences yet
    await _categoryRepository.saveCategory(category);
  }

  // SET MATCH

  /// Upload Match data (insert)
  Future<void> saveMatch(Match match) async {

    await _matchRepository.saveMatch(match);

    // TODO Rimuovere giocatori con uuid null (significa che non sono necessari) altrimenti da errore nel getPlayersByIds

    // get players data that is needed to both update the players's matchesIds
    // and teams's playersIds
    List<String> matchPlayersIds = match.playersData.map((data) => data.playerId).toList();
    List<Player> matchPlayers = await _playerRepository.getPlayersByIds(matchPlayersIds);

    // Update teams's matchesIds, categoriesIds and playersIds
    await updateTeamFromMatch(match, match.getTeam1(), matchPlayersIds);
    await updateTeamFromMatch(match, match.getTeam2(), matchPlayersIds);

    // update players's matchesIds and also implicitly the player's
    // teamId and the player's name (that could had been edited in the MatchView)
    for(Player player in matchPlayers) {
      if(player.matchesIds == null)
        player.matchesIds = [];
      if(!player.matchesIds.contains(match.id)) {
        player.matchesIds.add(match.id);
        await _playerRepository.savePlayer(player);
      }
    }

  }

  // SET PLAYER

  Future<void> savePlayer(Player player) async {
    // if the player's teamId is changed, remove the player's id from the old team's playersIds
    Player oldPlayer = await _playerRepository.getPlayerById(player.id);
    if(oldPlayer != null && oldPlayer.teamId != player.teamId) {
      Team oldTeam = await _teamRepository.getTeamById(oldPlayer.teamId);
      oldTeam.playersIds.removeWhere((id) => id == oldPlayer.id);
      await _teamRepository.saveTeam(oldTeam);
    }


    await _playerRepository.savePlayer(player);

    // insert or update team's playerIds
    Team team = await _teamRepository.getTeamById(player.teamId);
    if(team.playersIds == null)
      team.playersIds = [];
    if(!team.playersIds.contains(player.id)) {
      team.playersIds.add(player.id);
      await _teamRepository.saveTeam(team);
    }

    // update for every match that the player has played the player's name
    List<Match> matches = await _matchRepository.getMatchesByIds(player.matchesIds);
    for(Match match in matches) {
      int index = match.playersData.indexWhere((data) => data.playerId == player.id);
      if(index > -1) {
        match.playersData[index].name = player.name;
        match.playersData[index].surname = player.surname;
        _matchRepository.saveMatch(match);
      } else {
        _logger.d("MatchPlayerData not found from player's matchesIds. Shouldn't happen! Player id: ${player.id} Match id: ${match.id}");
      }
    }

    // insert or update player's match notes separately
  }

  // SET PLAYER MATCH NOTES

  Future<void> savePlayerMatchNotes(PlayerMatchNotes playerMatchNotes) async {
    await _playerNotesRepository.savePlayerMatchNotes(playerMatchNotes);

    // update player's playerMatchNodesIds
    Player player = await _playerRepository.getPlayerById(playerMatchNotes.playerId);
    if(player.playerMatchNotesIds == null)
      player.playerMatchNotesIds = [];
    if(!player.playerMatchNotesIds.contains(playerMatchNotes.id)) {
      player.playerMatchNotesIds.add(playerMatchNotes.id);
      await _playerRepository.savePlayer(player);
    }

  }

  // INITIALIZE

  Future<void> _initializeRequestedTeamsAndCategories(SharedPreferences sharedPreferences) async {
    // get all stored teams
    List<Team> teams = await _teamRepository.getTeams();

    // get teams whose name is one of the requested teams
    final Iterable<Team> currentTeamsRequested = teams.where((element) {
      return requestedTeams.indexWhere((team) => element.name == team) != -1;
    });

    final currentTeamsNamesRequested = currentTeamsRequested.map((e) =>
    e.name);

    Team merateTeam;

    List<String> teamsIds = [];

    for (String teamName in requestedTeams) {
      if (!currentTeamsNamesRequested.contains(teamName)) {
        Team team = Team();
        team.name = teamName;
        team.categoriesIds = List();
        team.matchesIds = List();
        team.playersIds = List();
        if(teamName == mainRequestedTeam)
          merateTeam = team;
        teamsIds.add(team.id);
        _teamRepository.saveTeam(team);
      } else {
        int index = currentTeamsNamesRequested.toList().indexOf(teamName);
        if(index > -1) {
          teamsIds.add(currentTeamsRequested.elementAt(index).id);
          if(teamName == mainRequestedTeam)
            merateTeam = currentTeamsRequested.elementAt(index);
        }
      }
    }

    await sharedPreferences.setStringList(requestedTeamsIdsKey, teamsIds);

    List<Category> categories = await _categoryRepository.getCategories();
    final currentCategoriesRequested = categories.where((element) {
      return requestedCategories.indexWhere((cat) => element.name == cat) !=
          -1;
    });

    final currentCategoriesNamesRequested = currentCategoriesRequested.map((
        e) => e.name);

    List<String> categoriesIds = [];

    for (String catName in requestedCategories) {
      if (!currentCategoriesNamesRequested.contains(catName)) {
        Category category = Category();
        category.name = catName;
        categoriesIds.add(category.id);
        _categoryRepository.saveCategory(category);
      } else {
        int index = currentCategoriesNamesRequested.toList().indexOf(catName);
        if(index > -1)
          categoriesIds.add(currentCategoriesRequested.elementAt(index).id);
      }
    }

    // Add to the Merate team the requested categories
    merateTeam.categoriesIds = categoriesIds;
    // Update
    _teamRepository.saveTeam(merateTeam);
  }

}