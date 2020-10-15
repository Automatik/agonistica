import 'package:agonistica/core/models/Match.dart';

class MatchesViewArguments {

  final bool isNewMatch;
  final Match match;
  final Function(Match) onMatchDetailUpdate;

  MatchesViewArguments(this.isNewMatch, this.match, this.onMatchDetailUpdate);

}