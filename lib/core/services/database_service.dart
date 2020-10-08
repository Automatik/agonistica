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

  Future<List<Match>> getCategoryMatches(Category category) async {
    if(category == null || category.matchesIds == null || category.matchesIds.isEmpty)
      return Future.value(List<Match>());
    List<Match> matches = [];
    for(String id in category.matchesIds) {
      final snapshot = await _databaseReference.child(firebaseMatchesChild).child(id).once();
      if(snapshot.value != null)
        matches.add(Match.fromJson(snapshot.value));
    }
    return matches;
  }

  static Future<List<Team>> _getTeams(DatabaseReference teamsDatabaseReference) async {
    final DataSnapshot snapshot = await teamsDatabaseReference.once();
    List<Team> teams = [];
    Map<dynamic, dynamic> values = snapshot.value;
    if(values != null)
      values.forEach((key, value) => teams.add(Team.fromJson(value)));
    return teams;
  }

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
        category.matchesIds = List();
        category.playersIds = List();
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