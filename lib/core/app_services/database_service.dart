

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/assets/menu_assets.dart';
import 'package:agonistica/core/assets/team_assets.dart';
import 'package:agonistica/core/exceptions/not_found_exception.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/logger.dart';
import 'package:agonistica/core/models/app_user.dart';
import 'package:agonistica/core/models/category.dart';
import 'package:agonistica/core/models/menu.dart';
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
import 'package:agonistica/core/utils/prefs_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:logger/logger.dart';

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
  late final AppStateService _appStateService = locator<AppStateService>();

  static Logger _logger = getLogger('DatabaseService');

  late final AppUserService _appUserService;
  late final FirebaseAuthUserService _firebaseAuthUserService;
  late final CategoryService _categoryService;
  late final FollowedPlayersService _followedPlayersService;
  late final FollowedTeamsService _followedTeamsService;
  late final MatchService _matchService;
  late final MenuService _menuService;
  late final PlayerNotesService _playerNotesService;
  late final PlayerService _playerService;
  late final SeasonPlayerService _seasonPlayerService;
  late final SeasonService _seasonService;
  late final SeasonTeamService _seasonTeamService;
  late final TeamService _teamService;

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
  }

  Future<void> _initializeAuthServices() async {
    _appUserService = AppUserService(_databaseReference);
    _firebaseAuthUserService = FirebaseAuthUserService(_firebaseAuth, _databaseReference);
  }

  Future<AppUser> fetchAppUser() async {
    String userId = await (PrefsUtils.getUserId() as Future<String>);
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

  Future<HomeMenus> getHomeMenus() async {
    List<Menu> followedTeamsMenus = await menuService.getFollowedTeamsMenus();
    List<Menu> followedPlayersMenus = await menuService.getFollowedPlayersMenus();
    return HomeMenus.from(followedTeamsMenus, followedPlayersMenus);
  }

  Future<Menu?> createNewMenu(String menuName, int menuType) async {
    // associate image filename
    List<String> usedMenuImages = await menuService.getUsedMenuImages();
    String menuImageFilename = MenuAssets.getNewImage(usedMenuImages);

    if(menuType == Menu.TYPE_FOLLOWED_TEAMS) {
      // Create team with the menu name
      Team team = await createNewTeam(menuName);
      await teamService.saveItem(team);
      // Create menu
      Menu menu = Menu.createTeamMenu(menuName, team.id!, menuImageFilename);
      await menuService.saveItem(menu);
      return menu;
    }
    if(menuType == Menu.TYPE_FOLLOWED_PLAYERS) {
      // Create menu with currently no category
      Menu menu = Menu.createPlayersMenu(menuName, List.empty(), menuImageFilename);
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