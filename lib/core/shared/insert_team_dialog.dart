import 'package:agonistica/core/models/Team.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class InsertTeamDialog {

  final String initialValue;
  final double maxHeight;
  final List<Team> Function(String) suggestionCallback;
  final Function(Team) onSubmit;

  InsertTeamDialog({
    this.initialValue,
    @required this.maxHeight,
    @required this.suggestionCallback,
    @required this.onSubmit,
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
          suggestionCallback: suggestionCallback,
          onSubmit: onSubmit,
        ),
      )
    );
  }

}

class _InsertTeamForm extends StatefulWidget {

  final String initialValue;
  final double maxHeight;
  final List<Team> Function(String) suggestionCallback;
  final Function(Team) onSubmit;

  _InsertTeamForm({
    this.initialValue,
    this.maxHeight,
    this.suggestionCallback,
    this.onSubmit,
  });

  @override
  State<StatefulWidget> createState() => _InsertTeamFormState();

}

class _InsertTeamFormState extends State<_InsertTeamForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  bool _isLoadingSuggestions = true;
  List<Team> suggestionsList;

  @override
  void initState() {
    super.initState();
    textEditingController.text = widget.initialValue ?? "";
    loadSuggestions();
  }

  @override
  Widget build(BuildContext context) {

    double maxDialogHeight = 0.7 * widget.maxHeight;

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
                        print("onChanged value: $value");
                        //TODO Send pattern
                      },
                      validator: (value) {
                        //TODO Aggiungere controlli di validation
                        if(value.isEmpty) {
                          return "Inserisci o seleziona una squadra";
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
                    onPressed: () {
                      if(_formKey.currentState.validate()) {
                        _formKey.currentState.save();
                        Team team = submitFinalValue();
                        widget.onSubmit.call(team);
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
//            indicator(),
          ],
        ),
      ),
    );
  }

  Future<void> loadSuggestions() async {
    String pattern = "";
    suggestionsList = widget.suggestionCallback.call(pattern);
    print("suggestions called!");
    setState(() {
      _isLoadingSuggestions = false;
    });
  }

  Team submitFinalValue() {
    //textEditingController.text is already validated

    // team's name should be unique to use this comparison in order to find which team is selected
    String text = textEditingController.text;
    Team team = suggestionsList.firstWhere((element) => element.name == text, orElse: () => Team.name(text));
    return team;
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

  Widget listView(List<Team> elements) {
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
            String suggestion = elements[index].name;
            return GestureDetector(
              onTap: () {
                this.textEditingController.text = suggestion;
              },
              child: ListTile(
                dense: true,
                title: Text(suggestion),
              ),
            );
          }
        ),
      ),
    );
  }

}