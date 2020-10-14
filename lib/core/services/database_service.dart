import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/core/models/Match.dart';
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
//    int i = 0;
//    Team merateTeam;
//    while(merateTeam == null && i < teamsIds.length) {
//      final snapshot = await _databaseReference.child(firebaseTeamsChild).child(teamsIds[i]).once();
//      final teamValue = snapshot.value;
//      if(teamValue != null && Team.fromJson(teamValue).name == mainRequestedTeam)
//        merateTeam = Team.fromJson(teamValue);
//    }
//    List<Category> categories = [];
//    if(merateTeam != null) {
//      // Get Categories
//      for(String catId in merateTeam.categoriesIds) {
//        final snapshot = await _databaseReference.child(firebaseCategoriesChild).child(catId).once();
//        final catValue = snapshot.value;
//        if(catValue != null)
//          categories.add(Category.fromJson(catValue));
//      }
//      mainTeam = merateTeam;
//    }
//    mainCategories = categories;
    mainCategories = await _categoryRepository.getCategoriesByIds(merateTeam.categoriesIds);
    return mainCategories;
  }

  /// Download all the matches of a team by filtering for the given category
  Future<List<Match>> getTeamMatchesByCategory(Team team, Category category) async {
    if(team == null || team.categoriesIds == null || team.categoriesIds.isEmpty ||
        team.matchesIds == null || team.matchesIds.isEmpty || category == null)
      return Future.value(List<Match>());
//    List<Match> matches = [];
//    for(String id in team.matchesIds) {
//      final snapshot = await _databaseReference.child(firebaseMatchesChild).child(id).once();
//      if(snapshot.value != null) {
//        Match match = Match.fromJson(snapshot.value);
//        if(match.categoryId == category.id)
//          matches.add(match);
//      }
//    }
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

  /// Download players of the given team and category
  Future<List<Player>> getPlayersByTeamAndCategory(String teamId, String categoryId) async {
    Team team = await _teamRepository.getTeamById(teamId);
    if(team == null || team.playersIds == null || team.playersIds.isEmpty)
      return Future.value(List<Player>());
//    List<Player> players = [];
//    for(String playerId in team.playersIds) {
//      final snapshot = await _databaseReference.child(firebasePlayersChild).child(playerId).once();
//      if(snapshot.value != null) {
//        Player player = Player.fromJson(snapshot.value);
//        if(player.categoryId == categoryId)
//          players.add(player);
//      }
//    }
    List<Player> players = await _playerRepository.getPlayersByIds(team.playersIds);
    players.removeWhere((player) => player.categoryId != categoryId);
    return players;
  }

  /// Download the player's notes
  Future<List<PlayerMatchNotes>> getPlayerNotesByPlayer(Player player) async {
    if(player == null || player.playerMatchNotesIds == null || player.playerMatchNotesIds.isEmpty)
      return Future.value(List<PlayerMatchNotes>());
//    List<PlayerMatchNotes> playersNotes = [];
//    for(String id in player.playerMatchNotesIds) {
//      final snapshot = await _databaseReference.child(firebasePlayersNotesChild).child(id).once();
//      if(snapshot.value != null) {
//        PlayerMatchNotes notes = PlayerMatchNotes.fromJson(snapshot.value);
//        playersNotes.add(notes);
//      }
//    }
    List<PlayerMatchNotes> playerMatchNotes = await _playerNotesRepository.getPlayersNotesByIds(player.playerMatchNotesIds);
    return playerMatchNotes;
  }

  /// Upload Team data (update)
  Future<void> updateTeamFromMatch(Match match, Team team) async {
    Team copy = await _teamRepository.getTeamById(team.id);
    if(copy != null) {
      team = copy;
    }
    if(team.categoriesIds == null)
      team.categoriesIds = [];
    if(!team.categoriesIds.contains(match.categoryId))
      team.categoriesIds.add(match.categoryId);
    if(team.matchesIds == null)
      team.matchesIds = [];
    if(!team.matchesIds.contains(match.id))
      team.matchesIds.add(match.id);

    //TODO playersIds

//    await _databaseReference.child(firebaseTeamsChild).child(team.id).set(team.toJson());
    _teamRepository.saveTeam(team);
  }



  /// Upload Match data (insert)
  Future<void> saveMatch(Match match) async {

    await _matchRepository.saveMatch(match);

    // Update teams
    await updateTeamFromMatch(match, match.getTeam1());
    await updateTeamFromMatch(match, match.getTeam2());

    // Should update also players ?

  }

  Future<void> savePlayer(Player player) async {
    await _playerRepository.savePlayer(player);
  }

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
//        _databaseReference.child(firebaseTeamsChild).child(team.id).set(
//            team.toJson());
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
//    _databaseReference.child(firebaseTeamsChild).child(merateTeam.id).set(merateTeam.toJson());
    _teamRepository.saveTeam(merateTeam);
  }

}