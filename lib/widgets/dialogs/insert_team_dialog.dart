import 'package:agonistica/core/app_services/database_service.dart';
import 'package:agonistica/core/locator.dart';
import 'package:agonistica/core/models/season_team.dart';
import 'package:agonistica/core/models/team.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:agonistica/core/utils/input_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class InsertTeamDialog {

  final String? initialValue;
  final double maxHeight;
  final String seasonId;
  final List<SeasonTeam> Function(String) suggestionCallback;
  final String? Function(String)? isInsertedTeamValid;
  final Function(SeasonTeam) onSubmit;

  InsertTeamDialog({
    this.initialValue,
    required this.maxHeight,
    required this.seasonId,
    required this.suggestionCallback,
    required this.onSubmit,
    this.isInsertedTeamValid,
  });

  Future<void> showInsertTeamDialog(BuildContext context) async {

    await showPlatformDialog(
      context: context,
      builder: (_) => PlatformAlertDialog(
        title: Text(
          "Inserisci una squadra",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: blueAgonisticaColor,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        material: (_, __) => MaterialAlertDialogData(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          )
        ),
        content: _InsertTeamForm(
          initialValue: initialValue,
          maxHeight: maxHeight,
          seasonId: seasonId,
          suggestionCallback: suggestionCallback,
          onSubmit: onSubmit,
          isInsertedTeamValid: isInsertedTeamValid,
        ),
      )
    );
  }

}

class _InsertTeamForm extends StatefulWidget {

  final String? initialValue;
  final double maxHeight;
  final String seasonId;
  final List<SeasonTeam> Function(String) suggestionCallback;
  final String? Function(String)? isInsertedTeamValid;
  final Function(SeasonTeam) onSubmit;

  _InsertTeamForm({
    this.initialValue,
    required this.maxHeight,
    required this.seasonId,
    required this.suggestionCallback,
    required this.onSubmit,
    this.isInsertedTeamValid,
  });

  @override
  State<StatefulWidget> createState() => _InsertTeamFormState();

}

class _InsertTeamFormState extends State<_InsertTeamForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  bool _isLoadingSuggestions = true;
  late List<SeasonTeam> suggestionsList;

  @override
  void initState() {
    super.initState();
    textEditingController.text = getTeamInitialValue()!;
    String pattern = "";
    loadSuggestions(pattern);
  }

  String? getTeamInitialValue() {
    if(widget.initialValue == null) {
      return "";
    }
    if(widget.initialValue == Team.EMPTY_TEAM_NAME) {
      return "";
    }
    return widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {

    InputBorder border = OutlineInputBorder(
      borderSide: BorderSide(color: blueAgonisticaColor),
    );

    return Container(
      constraints: BoxConstraints(
        maxHeight: 0.6 * MediaQuery.of(context).size.height,
        maxWidth: 0.9 * MediaQuery.of(context).size.width,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
                children: [
                  Flexible(
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        enabledBorder: border,
                        border: border,
                        focusedBorder: border,
                        errorMaxLines: 3,
                      ),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: blueAgonisticaColor,
                      ),
                      autofocus: false,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        bool isNameValid = InputValidation.validateTeamName(value) == null;
                        if(isNameValid)
                          loadSuggestions(value);
                      },
                      validator: (value) {
                        String? nameValidationResult = InputValidation.validateTeamName(value!);
                        bool isNameValid = nameValidationResult == null;
                        if(!isNameValid) {
                          return nameValidationResult;
                        }
                        if(widget.isInsertedTeamValid != null) {
                          String? insertedTeamValidationResult = widget.isInsertedTeamValid!(value);
                          bool isInsertedTeamValid = insertedTeamValidationResult == null;
                          if(!isInsertedTeamValid) {
                            return insertedTeamValidationResult;
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 10,),
                  PlatformButton(
                    child: PlatformText(
                      "Ok",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: () async {
                      if(_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        SeasonTeam seasonTeam = await submitFinalValue();
                        widget.onSubmit(seasonTeam);
                      }
                    },
                    material: (_, __) => MaterialRaisedButtonData(
                      color: blueAgonisticaColor,
                    ),
                    cupertino: (_, __) => CupertinoButtonData(
                      color: blueAgonisticaColor,
                    ),
                  )
                ]
            ),
            suggestions(),
          ],
        ),
      ),
    );
  }

  void loadSuggestions(String pattern) {
    suggestionsList = widget.suggestionCallback.call(pattern);
    setState(() {
      _isLoadingSuggestions = false;
    });
  }

  Future<SeasonTeam> submitFinalValue() async {
    //textEditingController.text is already validated

    // team's name should be unique to use this comparison in order to find which team is selected
    String text = textEditingController.text;
    SeasonTeam team;
    int index = suggestionsList.indexWhere((element) => element.getTeamName() == text);
    if(index == -1) {
      // no team exists with this name
      team = await createNewSeasonTeam(text, widget.seasonId);
    } else {
      // a team already exists with this name
      team = suggestionsList[index];
    }
    return team;
  }

  Future<SeasonTeam> createNewSeasonTeam(String text, String seasonId) async {
    DatabaseService databaseService = locator<DatabaseService>();
    return await databaseService.createNewSeasonTeamAndTeam(text, seasonId);
  }

  Widget suggestions() {
    return _isLoadingSuggestions
    ? indicator()
    : listView(suggestionsList);
  }

  Widget indicator() {
    return Container(
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 20, bottom: 20),
      width: 50,
      height: 50,
      child: CircularProgressIndicator(
        backgroundColor: Colors.transparent,
        valueColor: AlwaysStoppedAnimation(blueAgonisticaColor),
        strokeWidth: 4,
      ),
    );
  }

  Widget listView(List<SeasonTeam> elements) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 20),
        width: 300,
        height: 300,
        child: ListView.builder(
//          shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: elements.length,
            itemBuilder: (context, index) {
              String suggestion = elements[index].getTeamName()!;
              return ListTile(
                onTap: () => this.textEditingController.text = suggestion,
                dense: true,
                title: Text(suggestion),
              );
            }
        ),
      ),
    );
  }

}