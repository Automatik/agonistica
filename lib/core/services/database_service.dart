import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/Category.dart';
import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/Team.dart';
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

  final DatabaseReference _databaseReference = FirebaseDatabase(databaseURL: "https://agonistica-67769.firebaseio.com/").reference();

  static Logger _logger = getLogger('DatabaseService');

  Team mainTeam;
  List<Team> mainTeams;
  List<Category> mainCategories;

  Team selectedTeam;
  Category selectedCategory;

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
    List<Team> allTeams = await _getTeams(_databaseReference.child(firebaseTeamsChild));
    allTeams.removeWhere((team) => requestedTeamsIds.contains(team.id));
    return allTeams;
  }

  /// Get List of the requested Teams
  Future<List<Team>> getMainTeams() async {
    final sharedPref = await SharedPreferences.getInstance();
    List<String> teamsIds = sharedPref.getStringList(requestedTeamsIdsKey);
    List<Team> teams = List();
    for(String teamId in teamsIds) {
      final snapshot = await _databaseReference.child(firebaseTeamsChild).child(teamId).once();
      final teamValue = snapshot.value;
      if(teamValue != null)
        teams.add(Team.fromJson(teamValue));
    }
    mainTeams = teams;
    return teams;
  }

  /// Get List of the requested categories of the main team (Merate)
  Future<List<Category>> getMainCategories() async {
    // main categories from Merate Team
    final sharedPref = await SharedPreferences.getInstance();
    List<String> teamsIds = sharedPref.getStringList(requestedTeamsIdsKey);

    // Find Merate Team
    int i = 0;
    Team merateTeam;
    while(merateTeam == null && i < teamsIds.length) {
      final snapshot = await _databaseReference.child(firebaseTeamsChild).child(teamsIds[i]).once();
      final teamValue = snapshot.value;
      if(teamValue != null && Team.fromJson(teamValue).name == mainRequestedTeam)
        merateTeam = Team.fromJson(teamValue);
    }
    List<Category> categories = [];
    if(merateTeam != null) {
      // Get Categories
      for(String catId in merateTeam.categoriesIds) {
        final snapshot = await _databaseReference.child(firebaseCategoriesChild).child(catId).once();
        final catValue = snapshot.value;
        if(catValue != null)
          categories.add(Category.fromJson(catValue));
      }
      mainTeam = merateTeam;
    }
    mainCategories = categories;
    return categories;
  }

  /// Download all the matches of a team by filtering for the given category
  Future<List<Match>> getTeamMatchesByCategory(Team team, Category category) async {
    if(team == null || team.categoriesIds == null || team.categoriesIds.isEmpty ||
        team.matchesIds == null || team.matchesIds.isEmpty || category == null)
      return Future.value(List<Match>());
    List<Match> matches = [];
    for(String id in team.matchesIds) {
      final snapshot = await _databaseReference.child(firebaseMatchesChild).child(id).once();
      if(snapshot.value != null) {
        Match match = Match.fromJson(snapshot.value);
        if(match.categoryId == category.id)
          matches.add(match);
      }
    }
    return matches;
  }

  /// Download missing info for a given list of matches. For instance download the teams' names
  /// present in the matches list
  Future<List<Match>> completeMatchesWithMissingInfo(List<Match> matches) async {
    List<Match> newMatches = [];
    for(Match match in matches) {
      // Get teams' name
      Team tempTeam = await getTeamById(match.team1Id);
      match.team1Name = tempTeam?.name;
      tempTeam = await getTeamById(match.team2Id);
      match.team2Name = tempTeam?.name;
      newMatches.add(match);
    }
    return newMatches;
  }

  /// Download Team data given its id
  Future<Team> getTeamById(String teamId) async {
    final DataSnapshot snapshot = await _databaseReference.child(firebaseTeamsChild).child(teamId).once();
    Team team;
    if(snapshot.value != null) {
      team = Team.fromJson(snapshot.value);
    }
    return team;
  }

  /// Upload Team data (insert)
  Future<void> saveTeam(Team team) async {
    await _databaseReference.child(firebaseTeamsChild).child(team.id).set(team.toJson());
  }

  /// Upload Team data (update)
  Future<void> updateTeamFromMatch(Match match, Team team) async {
    Team copy = await getTeamById(team.id);
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

    await _databaseReference.child(firebaseTeamsChild).child(team.id).set(team.toJson());
  }

  /// Upload Match data (insert)
  Future<void> saveMatch(Match match) async {
    // it's not necessary to download a full copy of the match object because
    // the match object provided contains already all the data and thus no
    // update is needed
    // (could be different in case of changes to the Match's model)
    await _databaseReference.child(firebaseMatchesChild).child(match.id).set(match.toJson());

    // Update teams
    await updateTeamFromMatch(match, match.getTeam1());
    await updateTeamFromMatch(match, match.getTeam2());

    // Should update also players ?

  }

  /// Download all teams in firebase
  static Future<List<Team>> _getTeams(DatabaseReference teamsDatabaseReference) async {
    final DataSnapshot snapshot = await teamsDatabaseReference.once();
    List<Team> teams = [];
    Map<dynamic, dynamic> values = snapshot.value;
    if(values != null)
      values.forEach((key, value) => teams.add(Team.fromJson(value)));
    return teams;
  }

  /// Download all categories in firebase
  static Future<List<Category>> _getCategories(DatabaseReference categoriesDatabaseReference) async {
    final DataSnapshot snapshot = await categoriesDatabaseReference.once();
    List<Category> categories = [];
    Map<dynamic, dynamic> values = snapshot.value;
    if(values != null)
      values.forEach((key, value) => categories.add(Category.fromJson(value)));
    return categories;
  }

  Future<void> _initializeRequestedTeamsAndCategories(SharedPreferences sharedPreferences) async {
    // get all stored teams
    List<Team> teams = await _getTeams(
        _databaseReference.child(firebaseTeamsChild).reference());

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
        _databaseReference.child(firebaseTeamsChild).child(team.id).set(
            team.toJson());
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

    List<Category> categories = await _getCategories(
        _databaseReference.child(firebaseCategoriesChild).reference());
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
        _databaseReference.child(firebaseCategoriesChild)
            .child(category.id)
            .set(category.toJson());
      } else {
        int index = currentCategoriesNamesRequested.toList().indexOf(catName);
        if(index > -1)
          categoriesIds.add(currentCategoriesRequested.elementAt(index).id);
      }
    }

    // Add to the Merate team the requested categories
    merateTeam.categoriesIds = categoriesIds;
    // Update
    _databaseReference.child(firebaseTeamsChild).child(merateTeam.id).set(merateTeam.toJson());
  }

}