import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/widgets/text/custom_rich_text.dart';
import 'package:agonistica/widgets/dialogs/insert_team_dialog.dart';
import 'package:flutter/material.dart';

class TeamLabel extends StatefulWidget {

  final String teamName;
  final String seasonId;
  final bool isEditEnabled;
  final Function(String) onSuggestionTeamCallback;
  final Function(SeasonTeam) onTeamChange;
  final Color fontColor;
  final double fontSize;
  final FontWeight fontWeight;

  TeamLabel({
    @required this.teamName,
    @required this.seasonId,
    @required this.isEditEnabled,
    @required this.onSuggestionTeamCallback,
    @required this.onTeamChange,
    @required this.fontColor,
    @required this.fontWeight,
    @required this.fontSize,
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
        if(widget.isEditEnabled) {
          SeasonTeam seasonTeam = await _showInsertTeamDialog(context, teamText);
          if(seasonTeam != null) {
            setState(() {
              teamText = seasonTeam.getTeamName();
            });
            widget.onTeamChange(seasonTeam);
            //TODO Vedere se il close dialog piazzarlo qui o nel callback in PlayerDetailLayout
            // close dialog
            // Navigator.of(context).pop();
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

  Future<SeasonTeam> _showInsertTeamDialog(BuildContext context, String tempTeamName) async {
    SeasonTeam tempSeasonTeam;
    InsertTeamDialog insertTeamDialog = InsertTeamDialog(
        initialValue: tempTeamName,
        maxHeight: MediaQuery.of(context).size.height,
        seasonId: widget.seasonId,
        suggestionCallback: (pattern) {
          return widget.onSuggestionTeamCallback(pattern);
        },
        onSubmit: (finalTeamValue) {
          Navigator.of(context).pop();
          if(finalTeamValue != null) {
            tempSeasonTeam = finalTeamValue;
          }
        }
    );
    await insertTeamDialog.showInsertTeamDialog(context);
    return tempSeasonTeam;
  }

}