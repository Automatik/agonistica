import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/views/categories/categories_view.dart';
import 'package:agonistica/views/home/home_view.dart';
import 'package:agonistica/views/matches/matches_view.dart';
import 'package:agonistica/views/roster/roster_view.dart';
import 'package:agonistica/views/team/team_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocatorInjector.setupLocator();
  runApp(MyApp());
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
            initialRoute: '/home',
            routes: {
              HomeView.routeName: (context) => HomeView(),
              CategoriesView.routeName: (context) => CategoriesView(),
              MatchesView.routeName: (context) => MatchesView(),
              RosterView.routeName: (context) => RosterView(),
              TeamView.routeName: (context) => TeamView(),
            },
          );
        },
      ),
    );
  }
}
