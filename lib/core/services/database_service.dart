import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/services/category_service.dart';
import 'package:agonistica/core/services/followed_players_service.dart';
import 'package:agonistica/core/services/followed_teams_service.dart';
import 'package:agonistica/core/services/match_service.dart';
import 'package:agonistica/core/services/menu_service.dart';
import 'package:agonistica/core/services/player_notes_service.dart';
import 'package:agonistica/core/services/player_service.dart';
import 'package:agonistica/core/services/season_player_service.dart';
import 'package:agonistica/core/services/season_service.dart';
import 'package:agonistica/core/services/season_team_service.dart';
import 'package:agonistica/core/services/team_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {

  static const String firebaseUsersChild = "users";
  static const String firebasePermissionsChild = "permissions";
  static const String firebaseTeamsChild = "teams";
  static const String firebaseMenusChild = "menus";
  static const String firebaseSeasonsChild = "seasons";
  static const String firebaseCategoriesChild = "categories";
  static const String firebaseMatchesChild = "matches";
  static const String firebasePlayersChild = "players";
  static const String firebaseSeasonPlayersChild = "seasonPlayers";
  static const String firebaseSeasonTeamsChild = "seasonTeams";
  static const String firebasePlayersNotesChild = "playersNotes";
  static const String firebaseFollowedPlayersChild = "followedPlayers";
  static const String firebaseFollowedTeamsChild = "followedTeams";

  final DatabaseReference _databaseReference = FirebaseDatabase(databaseURL: "https://agonistica-67769.firebaseio.com/").reference();

  static Logger _logger = getLogger('DatabaseService');

  CategoryService _categoryService;
  FollowedPlayersService _followedPlayersService;
  FollowedTeamsService _followedTeamsService;
  MatchService _matchService;
  MenuService _menuService;
  PlayerNotesService _playerNotesService;
  PlayerService _playerService;
  SeasonPlayerService _seasonPlayerService;
  SeasonService _seasonService;
  SeasonTeamService _seasonTeamService;
  TeamService _teamService;


  CategoryService get categoryService => _categoryService;
  Team mainTeam;
  List<Team> mainTeams;
  List<Category> mainCategories;

  Team selectedTeam;
  Category selectedCategory;

  Future<void> initialize() async {
    await _initializeServices();
    await _initializeData();
  }

  Future<void> _initializeServices() async {
    _categoryService = CategoryService(_databaseReference);
    _followedPlayersService = FollowedPlayersService(_databaseReference);
    _followedTeamsService = FollowedTeamsService(_databaseReference);
    _matchService = MatchService(_databaseReference);
    _menuService = MenuService(_databaseReference);
    _playerNotesService = PlayerNotesService(_databaseReference);
    _playerService = PlayerService(_databaseReference);
    _seasonPlayerService = SeasonPlayerService(_databaseReference);
    _seasonService = SeasonService(_databaseReference);
    _seasonTeamService = SeasonTeamService(_databaseReference);
    _teamService = TeamService(_databaseReference);
  }

  Future<void> _initializeData() async {
    // Initialize database if needed with requested teams and categories
    final sharedPref = await SharedPreferences.getInstance();
    bool areItemsInitialized = sharedPref.getBool(areItemsInitializedKey) ?? false;
    if(!areItemsInitialized) {
      // Create categories for the main menu
      List<Category> categories = await _initializeCategories();
      // Create menus in HomeView
      List<Menu> menus = await _initializeMenus(categories);
      // Create the first season, the current one
      Season season = await _initializeCurrentSeason();
      // Create the main teams (currently only the Merate Team)
      List<String> teamNames = List.of([mainRequestedTeam]);
      List<Team> teams = await _initializeRequestedTeams(teamNames);
      // Create the season teams
      List<List<Category>> teamsCategories = List.of([categories]);
      await _initializeRequestedSeasonTeams(teams, teamsCategories, season);
      // Follow this teams
      await _initializeFollowedTeams(teams);
      sharedPref.setBool(areItemsInitializedKey, true);
    }
  }

  Future<List<Category>> _initializeCategories() async {
    List<Category> categories = [];
    for(String categoryName in requestedCategories) {
      Category category = Category.name(categoryName);
      await categoryService.saveItem(category);
      categories.add(category);
    }
    return categories;
  }

  Future<List<Menu>> _initializeMenus(List<Category> mainMenuCategories) async {
    List<Menu> menus = [];
    for(String menuName in requestedMenus) {
      Menu menu;
      if(menuName == mainRequestedTeam) {
        menu = Menu.create(menuName, Menu.TYPE_FOLLOWED_TEAMS);
        menu.categoriesIds = mainMenuCategories.map((e) => e.id).toList();
      } else {
        menu = Menu.create(menuName, Menu.TYPE_FOLLOWED_PLAYERS);
      }
      await menuService.saveItem(menu);
      menus.add(menu);
    }
    return menus;
  }

  Future<Season> _initializeCurrentSeason() async {
    Season season = Season.createCurrentSeason();
    await seasonService.saveItem(season);
    return season;
  }

  Future<List<Team>> _initializeRequestedTeams(List<String> teamNames) async {
    List<Team> teams = [];
    for(String teamName in teamNames) {
      Team team = Team.name(teamName);
      await teamService.saveItem(team);
      teams.add(team);
    }
    return teams;
  }

  /// For every team in the teams list create a season team with the given categories
  /// in the list of teamsCategories and with the season provided
  Future<void> _initializeRequestedSeasonTeams(List<Team> teams, List<List<Category>> teamsCategories, Season season) async {
    if(teams.length != teamsCategories.length) {
      return;
    }
    for(int i=0; i<teams.length; i++) {
      Team team = teams[i];
      List<Category> categories = teamsCategories[i];
      SeasonTeam seasonTeam = SeasonTeam.empty(team.id, season.id);
      seasonTeam.categoriesIds = categories.map((e) => e.id).toList();
      await seasonTeamService.saveItem(seasonTeam);
    }
  }

  Future<void> _initializeFollowedTeams(List<Team> teams) async {
    FollowedTeams followedTeams = FollowedTeams.empty();
    followedTeams.teamsIds = teams.map((e) => e.id).toList();
    await followedTeamsService.saveItem(followedTeams);
  }

  FollowedPlayersService get followedPlayersService => _followedPlayersService;

  FollowedTeamsService get followedTeamsService => _followedTeamsService;

  MatchService get matchService => _matchService;

  MenuService get menuService => _menuService;

  PlayerNotesService get playerNotesService => _playerNotesService;

  PlayerService get playerService => _playerService;

  SeasonPlayerService get seasonPlayerService => _seasonPlayerService;

  SeasonService get seasonService => _seasonService;

  SeasonTeamService get seasonTeamService => _seasonTeamService;

  TeamService get teamService => _teamService;
}