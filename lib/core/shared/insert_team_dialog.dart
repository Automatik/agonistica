import 'package:agonistica/core/shared/base_widget.dart';
import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InsertTeamDialog extends StatefulWidget {

  //TODO Add check if team's name is already present in db!

  final String initialValue;
  final double maxHeight;
  final Function(String) suggestionCallback;
  final Function(String) onSubmit;

  InsertTeamDialog({
    this.initialValue,
    @required this.maxHeight,
    @required this.suggestionCallback,
    @required this.onSubmit,
  });

  @override
  State<StatefulWidget> createState() => _InsertTeamDialogState();


}

//  Future<void> showInsertTeamDialog(BuildContext context) async {
//
//    await showPlatformDialog(
//      context: context,
//      builder: (_) => PlatformAlertDialog(
//        title: Text(
//          "Inserisci una squadra",
//          textAlign: TextAlign.center,
//          style: TextStyle(
//            color: blueAgonisticaColor,
//            fontSize: 20,
//            fontWeight: FontWeight.bold,
//          ),
//        ),
//        material: (_, __) => MaterialAlertDialogData(
//          backgroundColor: Colors.white,
//          shape: RoundedRectangleBorder(
//            borderRadius: BorderRadius.circular(12),
//          )
//        ),
//        content: _InsertTeamForm(
//          initialValue: initialValue,
//          maxHeight: maxHeight,
//          suggestionCallback: suggestionCallback,
//          onSubmit: onSubmit,
//        ),
//      )
//    );
//  }
//
//}

//class _InsertTeamForm extends StatefulWidget {
//
//  final String initialValue;
//  final double maxHeight;
//  final Function(String) suggestionCallback;
//  final Function(String) onSubmit;
//
//  _InsertTeamForm({
//    this.initialValue,
//    this.maxHeight,
//    this.suggestionCallback,
//    this.onSubmit,
//  });
//
//  @override
//  State<StatefulWidget> createState() => _InsertTeamFormState();
//
//}

class _InsertTeamDialogState extends State<InsertTeamDialog> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
//  final SuggestionsBoxController suggestionsBoxController = SuggestionsBoxController();
//  String _insertedTeam;

  @override
  void initState() {
    super.initState();
    _typeAheadController.text = widget.initialValue ?? "";
  }

  @override
  Widget build(BuildContext context) {

    double maxDialogHeight = 0.7 * widget.maxHeight;

    return BaseWidget(
      builder: (_, MySizingInformation sizingInformation) {
        return Align(
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              constraints: BoxConstraints(
                minWidth: 0.8 * sizingInformation.localWidgetSize.width,
                maxWidth: 0.8 * sizingInformation.localWidgetSize.width,
                minHeight: 0.6 * sizingInformation.localWidgetSize.height,
                maxHeight: 0.9 * sizingInformation.localWidgetSize.height,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Inserisci una squadra",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: blueAgonisticaColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  form(0.8 * sizingInformation.localWidgetSize.height),
                ],
              ),
            )
        );
      },
    );
  }

  Widget form(double maxDialogHeight) {
    return Form(
      key: _formKey,
      child: Container(
        constraints: BoxConstraints(
          minHeight: 0.5 * maxDialogHeight,
          maxHeight: maxDialogHeight,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: blueAgonisticaColor),
                    )
                ),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: blueAgonisticaColor,
                ),
                autofocus: true,
              ),
              suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  constraints: BoxConstraints(
                    maxHeight: 0.7 * maxDialogHeight,
                  )
              ),
//              suggestionsBoxController: suggestionsBoxController,
              suggestionsCallback: (pattern) async {
                List<String> sug = await widget.suggestionCallback.call(pattern);
//                suggestionsBoxController.open();
//                suggestionsBoxController.resize();
                return sug;
              },
              itemBuilder: (_, suggestion) {
                return GestureDetector(
                  onPanDown: (_) {
                    print("onPanDown suggestion: $suggestion");
                    this._typeAheadController.text = suggestion;
                  },
                  child: ListTile(
                    dense: true,
                    title: Text(suggestion),
                  ),
                );
              },
              keepSuggestionsOnLoading: true,
              keepSuggestionsOnSuggestionSelected: true,
              transitionBuilder: (_, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                //Not working!
                print("suggestion: $suggestion");
                this._typeAheadController.text = suggestion;
              },
              validator: (value) {
                if(value.isEmpty) {
                  return "Inserisci o seleziona una squadra";
                }
                return null;
              },
              onSaved: (value) {
                print("onSaved");
//              _insertedTeam = value;
              },
            ),
            SizedBox(height: 10,),
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
                  widget.onSubmit.call(_typeAheadController.text);
                }
              },
              material: (_, __) => MaterialRaisedButtonData(
                color: blueAgonisticaColor,
              ),
              cupertino: (_, __) => CupertinoButtonData(
                color: blueAgonisticaColor,
              ),
            )
          ],
        ),
      ),
    );
  }

}