import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/shared/custom_rich_text.dart';
import 'package:agonistica/core/shared/insert_team_dialog.dart';
import 'package:flutter/material.dart';

class TeamLabel extends StatefulWidget {

  final String teamName;
  final bool isEditEnabled;
  final Function(String) onSuggestionTeamCallback;
  final Function(Team) onTeamChange;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;

  TeamLabel({
    this.teamName,
    this.isEditEnabled,
    this.onSuggestionTeamCallback,
    this.onTeamChange,
    this.fontColor,
    this.fontWeight,
    this.fontSize,
  });

  @override
  State<StatefulWidget> createState() => _TeamLabelState();

}

class _TeamLabelState extends State<TeamLabel> {

  String teamText;

  @override
  void initState() {
    super.initState();
    teamText = widget.teamName;
  }

  @override
  Widget build(BuildContext context) {
    return CustomRichText(
      onTap: () async {
        // se faccio cambiare squadra, fare un metodo nel team repository per rimuovere il player id dal team's playerIds
        // e poi salvare il player nella nuova squadra (fatto, gestito nel savePlayer di databaseService)
        if(widget.isEditEnabled) {
          Team team = await _showInsertTeamDialog(context, teamText);
          if(team != null) {
            setState(() {
              teamText = team.name;
            });
            widget.onTeamChange(team);
          }
        }
      },
      enabled: widget.isEditEnabled,
      text: teamText,
      textAlign: TextAlign.start,
      fontColor: widget.fontColor,
      fontSize: widget.fontSize,
      fontWeight: widget.fontWeight,
    );
  }

  Future<Team> _showInsertTeamDialog(BuildContext context, String tempTeamName) async {
    Team tempTeam;
    InsertTeamDialog insertTeamDialog = InsertTeamDialog(
        initialValue: tempTeamName,
        maxHeight: MediaQuery.of(context).size.height,
        suggestionCallback: (pattern) {
          return widget.onSuggestionTeamCallback(pattern);
        },
        onSubmit: (finalTeamValue) {
          Navigator.of(context).pop();
          if(finalTeamValue != null) {
            tempTeam = finalTeamValue;
          }
        }
    );
    await insertTeamDialog.showInsertTeamDialog(context);
    return tempTeam;
  }

}