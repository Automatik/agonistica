import 'package:agonistica/core/models/Match.dart';
import 'package:agonistica/core/models/PlayerMatchNotes.dart';

class NotesViewArguments {

  final PlayerMatchNotes notes;
  final Match match;
  final String playerName;

  NotesViewArguments(this.notes, this.match, this.playerName);

}