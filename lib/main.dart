import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/prefs_utils.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:agonistica/views/home/home_view.dart';
import 'package:agonistica/views/login/login_view.dart';
import 'package:agonistica/views/matches/matches_view.dart';
import 'package:agonistica/views/notes/notes_view.dart';
import 'package:agonistica/views/player_matches/player_matches_view.dart';
import 'package:agonistica/views/players/players_view.dart';
import 'package:agonistica/views/roster/roster_view.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

bool _isRegistered, _isLogged;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initialize();
  await startAppBasedOnPrefs();
  runApp(MyApp());
}

Future<void> initialize() async {
  await initializeFirebase();
  await initializeServices();
}

Future<void> initializeFirebase() async {
  try {
    await Firebase.initializeApp();
    // set persistence here, before getting any database reference, otherwise persistence will not be enabled
    FirebaseDatabase.instance.setPersistenceEnabled(true);
  } catch(e) {
    print(e);
  }
}

Future<void> initializeServices() async {
  await LocatorInjector.setupLocator();
  await locator<DatabaseService>().initialize();
}

Future<void> startAppBasedOnPrefs() async {
  await getUserState();
}

Future<void> getUserState() async {
  _isRegistered = await PrefsUtils.isUserSignedUp();
  _isLogged = await PrefsUtils.isUserSignedIn();
  if(_isLogged) {
    // if the email is not verified, login again
    bool isEmailVerified = await PrefsUtils.isEmailVerified();
    if(!isEmailVerified) {
      _isLogged = false;
    } else {
      String appUserId = await PrefsUtils.getUserId();
      final appUser = await locator<DatabaseService>().appUserService.getItemById(appUserId);
      locator<AppStateService>().selectedAppUser = appUser;
    }
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if(!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null)
          currentFocus.focusedChild.unfocus();
      },
      child: PlatformProvider(
        builder: (BuildContext context) {
          return PlatformApp(
            title: 'Agonistica 2.0',
            material: (_, __) => MaterialAppData(
              theme: ThemeData(
                primaryColor: blueAgonisticaColor,
                accentColor: accentColor,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              )
            ),
            initialRoute: navigateToFirstRoute(),
            routes: {
              LoginView.routeName: (context) => LoginView(),
              HomeView.routeName: (context) => HomeView(),
              CategoriesView.routeName: (context) => CategoriesView(),
              MatchesView.routeName: (context) => MatchesView(),
              RosterView.routeName: (context) => RosterView(),
              TeamView.routeName: (context) => TeamView(),
              PlayersView.routeName: (context) => PlayersView(),
              PlayerMatchesView.routeName: (context) => PlayerMatchesView(),
              NotesView.routeName : (context) => NotesView(),
            },
          );
        },
      ),
    );
  }

  String navigateToFirstRoute() {
    // if(_isLogged) {
    //   return HomeView.routeName;
    // }
    return LoginView.routeName;
  }

}
