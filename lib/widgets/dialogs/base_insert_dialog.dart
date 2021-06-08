// @dart=2.9

import 'package:agonistica/core/shared/shared_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

abstract class BaseInsertDialog {

  final String Function(String) validateInput;
  final Function(String) onSubmit;

  BaseInsertDialog({
    @required this.validateInput,
    @required this.onSubmit
  });

  Future<void> showInsertDialog(BuildContext context) async {
    await showPlatformDialog(
        context: context,
        builder: (_) => PlatformAlertDialog(
          title: Text(
            getTitle(),
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
          content: _InsertForm(
            validateInput: validateInput,
            onSubmit: onSubmit,
          ),
        )
    );
  }

  String getTitle();

}

class _InsertForm extends StatefulWidget {

  final String Function(String) validateInput;
  final Function(String) onSubmit;

  _InsertForm({
    @required this.validateInput,
    @required this.onSubmit
  });

  @override
  State<StatefulWidget> createState() => _InsertFormState();

}

class _InsertFormState extends State<_InsertForm> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textEditingController.text = "";
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
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
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
                validator: (value) {
                  return widget.validateInput(value);
                },
              ),
            ),
            PlatformButton(
              child: PlatformText(
                "Crea",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
              onPressed: () async {
                if(_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  String value = textEditingController.text;
                  widget.onSubmit(value);
                }
              },
              material: (_, __) => MaterialRaisedButtonData(
                color: blueAgonisticaColor,
              ),
              cupertino: (_, __) => CupertinoButtonData(
                color: blueAgonisticaColor,
              ),
            ),
          ],
        ),
      ),
    );

  }

}