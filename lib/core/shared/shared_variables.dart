import 'package:flutter/material.dart';

const blueAgonisticaColor = Color.fromRGBO(28, 48, 121, 1);
const blueLightAgonisticaColor = Color.fromRGBO(0, 67, 143, 1);
const textDisabledColor = Color.fromRGBO(157, 159, 162, 1);
const appBarBackgroundColor = Colors.white;

const accentColor = Colors.white;

const String defaultAppBarTitle = "Agonistica 2.0";
//const String mainButtonTitle = "Merate";

const String mainRequestedTeam = 'Merate';
final List<String> requestedTeams = List.unmodifiable([mainRequestedTeam, 'Prima Squadra', 'Juniores', 'Allievi', 'Giovanissimi']);
final List<String> requestedCategories = List.unmodifiable(['Juniores Regionali A', 'Allievi Regionali A', 'Giovanissimi Regionali A']);


const String areTeamsAndCategoriesRequestedStoredKey = 'areTeamsAndCategoriesRequestedStored';
const String requestedTeamsIdsKey = 'requestedTeamsIds';