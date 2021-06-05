import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/assets/menu_assets.dart';
import 'package:agonistica/core/assets/team_assets.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/app_user.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/followed_players.dart';
import 'package:agonistica/core/models/followed_teams.dart';
import 'package:agonistica/core/models/menu.dart';
import 'package:agonistica/core/models/season.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/pojo/home_menus.dart';
import 'package:agonistica/core/services/app_user_service.dart';
import 'package:agonistica/core/services/category_service.dart';
import 'package:agonistica/core/services/firebase_auth_user_service.dart';
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
import 'package:agonistica/core/utils/prefs_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService {

  static const String firebaseUsersChild = "users";
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
  // store here the app users ids to avoid granting users full access to "users" directory
  // users_ids has as keys the firebase auth user id and as value the app user id
  static const String firebaseUsersIdsChild = "users_ids";

  static const bool REQUIRE_EMAIL_VERIFICATION = false; //TODO Set to true

  final DatabaseReference _databaseReference = FirebaseDatabase(databaseURL: "https://agonistica-67769.firebaseio.com/").reference();

  final _firebaseAuth = FirebaseAuth.instance;
  final _appStateService = locator<AppStateService>();

  static Logger _logger = getLogger('DatabaseService');

  AppUserService _appUserService;
  FirebaseAuthUserService _firebaseAuthUserService;
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

  /// Call this when opening the app
  Future<void> initialize() async {
    await _initializeAuthServices();
    bool isUserSignedIn = await PrefsUtils.isUserSignedIn();
    if(isUserSignedIn) {
      await initializeUser();
    }
  }

  /// Call this after the user has logged in or if the user is already signed in
  Future<void> initializeUser() async {
    AppUser appUser = await fetchAppUser();
    _appStateService.selectedAppUser = appUser;
    await _initializeDataServices();
    // await _initializeData(appUser);
  }

  Future<void> _initializeAuthServices() async {
    _appUserService = AppUserService(_databaseReference);
    _firebaseAuthUserService = FirebaseAuthUserService(_firebaseAuth, _databaseReference);
  }

  Future<AppUser> fetchAppUser() async {
    String userId = await PrefsUtils.getUserId();
    bool userExists = await _appUserService.itemExists(userId);
    if(!userExists) {
      throw NotFoundException("User with id $userId not found in database.");
    }
    AppUser appUser = await _appUserService.getItemById(userId);
    return appUser;
  }

  Future<void> _initializeDataServices() async {
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

  // Future<void> _initializeData(AppUser appUser) async {
  //   // Initialize database if needed with requested teams and categories
  //   if(!appUser.areItemsInitialized) {
  //     // Create categories for the main menu
  //     List<Category> categories = await _initializeCategories();
  //     // Create the first season, the current one
  //     Season season = await _initializeCurrentSeason();
  //     // Create the main teams (currently only the Merate Team)
  //     List<String> teamNames = List.of([mainRequestedTeam]);
  //     List<Team> teams = await _initializeRequestedTeams(teamNames);
  //     // Create the season teams
  //     List<List<Category>> teamsCategories = List.of([categories]);
  //     await _initializeRequestedSeasonTeams(teams, teamsCategories, season);
  //     // Follow this teams
  //     await _initializeFollowedTeams(teams);
  //     // Initialize FollowedPlayers (it will be empty)
  //     await _initializeFollowedPlayers();
  //     // Create menus in HomeView
  //     List<Menu> menus = await _initializeMenus(teams[0].id);
  //
  //     // Set that items are initialized
  //     appUser.areItemsInitialized = true;
  //     await _appUserService.saveItem(appUser);
  //   }
  // }
  //
  // Future<List<Category>> _initializeCategories() async {
  //   List<Category> categories = [];
  //   for(String categoryName in requestedMainTeamCategories) {
  //     Category category = Category.name(categoryName);
  //     await categoryService.saveItem(category);
  //     categories.add(category);
  //   }
  //   return categories;
  // }
  //
  // Future<Season> _initializeCurrentSeason() async {
  //   Season season = Season.createCurrentSeason();
  //   await seasonService.saveItem(season);
  //   return season;
  // }
  //
  // Future<List<Team>> _initializeRequestedTeams(List<String> teamNames) async {
  //   List<Team> teams = [];
  //   for(String teamName in teamNames) {
  //     Team team = Team.name(teamName);
  //     await teamService.saveItem(team);
  //     teams.add(team);
  //   }
  //   return teams;
  // }
  //
  // /// For every team in the teams list create a season team with the given categories
  // /// in the list of teamsCategories and with the season provided
  // Future<void> _initializeRequestedSeasonTeams(List<Team> teams, List<List<Category>> teamsCategories, Season season) async {
  //   if(teams.length != teamsCategories.length) {
  //     return;
  //   }
  //   for(int i=0; i<teams.length; i++) {
  //     Team team = teams[i];
  //     List<Category> categories = teamsCategories[i];
  //     SeasonTeam seasonTeam = SeasonTeam.empty(team.id, season.id);
  //     seasonTeam.categoriesIds = categories.map((e) => e.id).toList();
  //     await seasonTeamService.saveItem(seasonTeam);
  //   }
  // }
  //
  // Future<void> _initializeFollowedTeams(List<Team> teams) async {
  //   FollowedTeams followedTeams = FollowedTeams.empty();
  //   followedTeams.teamsIds = teams.map((e) => e.id).toList();
  //   await followedTeamsService.saveItem(followedTeams);
  // }
  //
  // Future<void> _initializeFollowedPlayers() async {
  //   FollowedPlayers followedPlayers = FollowedPlayers.empty();
  //   await followedPlayersService.saveItem(followedPlayers);
  // }
  //
  // Future<List<Menu>> _initializeMenus(String mainTeamId) async {
  //   List<Menu> menus = [];
  //   for(String menuName in requestedMenus) {
  //     Menu menu;
  //     if(menuName == mainRequestedTeam) {
  //       menu = Menu.createTeamMenu(menuName, Menu.TYPE_FOLLOWED_TEAMS, mainTeamId);
  //     } else {
  //       menu = Menu.createPlayersMenu(menuName, Menu.TYPE_FOLLOWED_PLAYERS, List());
  //     }
  //     await menuService.saveItem(menu);
  //     menus.add(menu);
  //   }
  //   return menus;
  // }

  Future<HomeMenus> getHomeMenus() async {
    List<Menu> followedTeamsMenus = await menuService.getFollowedTeamsMenus();
    List<Menu> followedPlayersMenus = await menuService.getFollowedPlayersMenus();
    return HomeMenus.from(followedTeamsMenus, followedPlayersMenus);
  }

  Future<Menu> createNewMenu(String menuName, int menuType) async {
    // associate image filename
    List<String> usedMenuImages = await menuService.getUsedMenuImages();
    String menuImageFilename = MenuAssets.getNewImage(usedMenuImages);

    if(menuType == Menu.TYPE_FOLLOWED_TEAMS) {
      // Create team with the menu name
      Team team = await createNewTeam(menuName);
      await teamService.saveItem(team);
      // Create menu
      Menu menu = Menu.createTeamMenu(menuName, team.id, menuImageFilename);
      await menuService.saveItem(menu);
      return menu;
    }
    if(menuType == Menu.TYPE_FOLLOWED_PLAYERS) {
      // Create menu with currently no category
      Menu menu = Menu.createPlayersMenu(menuName, List(), menuImageFilename);
      await menuService.saveItem(menu);
      return menu;
    }
    return null;
  }

  Future<Category> createNewCategory(String categoryName, List<String> otherCategoriesIds) async {
    // associate image filename
    List<String> usedCategoriesImages = await categoryService.getUsedCategoryImages(otherCategoriesIds);
    String categoryImageFilename = MenuAssets.getNewImage(usedCategoriesImages);
    Category category = Category.name(categoryName, categoryImageFilename);
    return category;
  }

  Future<Team> createNewTeam(String teamName) async {
    // associate image filename
    String teamImageFilename = await getNewTeamImage();

    // create team
    Team team = Team.name(teamName, teamImageFilename);
    return team;
  }

  /// Create both a new Team and a new SeasonTeam
  Future<SeasonTeam> createNewSeasonTeamAndTeam(String teamName, String seasonId) async {
    // Create new team
    Team team = await createNewTeam(teamName);

    // Create new season team
    return SeasonTeam.newTeam(team.name, team.imageFilename, seasonId);
  }

  Future<String> getNewTeamImage() async {
    List<String> usedTeamImages = await teamService.getUsedTeamImages();
    return TeamAssets.getNewImage(usedTeamImages);
  }

  CategoryService get categoryService => _categoryService;

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

  AppUserService get appUserService => _appUserService;

  FirebaseAuthUserService get firebaseAuthUserService => _firebaseAuthUserService;

}