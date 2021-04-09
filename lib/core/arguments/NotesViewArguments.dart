import 'package:agonistica/core/models/match.dart';
import 'package:agonistica/core/models/player_match_notes.dart';

class NotesViewArguments {

  final PlayerMatchNotes notes;
  final Match match;
  final String playerName;

  NotesViewArguments(this.notes, this.match, this.playerName);

}