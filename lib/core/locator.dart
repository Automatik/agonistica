// @dart=2.9

import 'package:agonistica/core/app_services/app_state_service.dart';
import 'package:agonistica/core/app_services/base_scaffold_service.dart';
import 'package:agonistica/core/app_services/database_service.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:agonistica/core/logger.dart';

final GetIt locator = GetIt.instance;

class LocatorInjector {

  static Logger _logger = getLogger('LocatorInjector');

  static Future<void> setupLocator() async {
    _logger.d('Setting up the locator and its services');
    locator.registerSingleton<BaseScaffoldService>(BaseScaffoldService());
    locator.registerLazySingleton(() => DatabaseService());
    locator.registerSingleton<AppStateService>(AppStateService());
  }

}